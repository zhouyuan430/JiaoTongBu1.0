//
//  JiaoTongBuClient.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-20.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "JiaoTongBuClient.h"
#import "GDataXMLNode.h"
#import "AppCode.h"
#import "AppDelegate.h"


static NSString * const JiaoTongBuBaseURLString = @"https://alpha-api.app.net/";

@implementation JiaoTongBuClient

+ (instancetype)sharedClient {
    static JiaoTongBuClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[JiaoTongBuClient alloc] initWithBaseURL:[NSURL URLWithString:JiaoTongBuBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    });
    
    AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
    AFHTTPResponseSerializer * responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _sharedClient.responseSerializer = responseSerializer;
    _sharedClient.requestSerializer = requestSerializer;

    return _sharedClient;
}

-(NSDictionary*)XMLParser:(NSData *)data
{
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    GDataXMLElement *rootElement = [doc rootElement];
    //节点
    GDataXMLElement *dicElement = [[rootElement elementsForName:@"ns:return"] objectAtIndex:0];
    
    //将NSString转换成NSDictionary
    NSString *tmp1 = [dicElement stringValue];
    
    NSData *tmp2 = [tmp1 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:tmp2 options:NSJSONReadingMutableContainers error:nil];
    return dic;
}

-(void)startGet:(NSInteger)_code parameters:(NSDictionary *)para withCallBack:(completCallBack)callBack
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示
    
    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    
    NSDictionary *parameters;
    NSString *URL;
    
    switch (_code)
    {
        case getContactPageListCode:
            parameters = @{@"uid":uid,@"token":token,@"page":para[@"page"],@"size":para[@"size"]};
            URL = getContactPageListURL;
            break;
        case loginCode:
            parameters = @{@"usrname":para[@"userName"],@"password":para[@"password"]};
            URL = loginURL;
            break;
        case getAssetPageListCode:
            parameters = @{@"uid":uid,@"keywd":para[@"keywd"],@"token":token,@"page":para[@"page"],@"size":para[@"size"]};
            URL = getAssetPageListURL;
            break;
        case getAuthListCode:
            parameters = @{@"uid":uid,
                            @"token":token,
                            @"keywd":para[@"keywd"],
                            @"searchItem":para[@"Item"],
                            @"page":para[@"page"],
                            @"size":para[@"size"]};
            URL = getAuthListURL;
            break;
        case applyRefundCode:
            parameters = @{@"aids":para[@"aids"],@"uid":uid,@"token":token};
            URL = applyRefundURL;
            break;
        case getCheckPageListCode:
            parameters = @{@"uid":uid,@"token":token,@"page":para[@"page"],@"size":para[@"size"]};
            URL = getCheckPageListURL;
            break;
        default:
            break;
    }
    
    [[JiaoTongBuClient sharedClient] GET:URL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        if ([dic[@"status"] isEqualToString:@"A0006"]){
            callBack(0,dic,nil);
        }
        else{
            callBack(1,dic,nil);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callBack(2,nil,error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

-(void)startPost:(NSInteger)_code parameters:(NSDictionary *)para withCallBack:(completCallBack)callBack
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示
    
    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    
    NSDictionary *parameters;
    NSString *URL;
    
    switch (_code) {
        case uploadAssetImagesCode:
            parameters =@{@"base64":para[@"base64"],@"uid":uid,@"token":token ,@"aid":para[@"aid"]};
            URL = uploadAssetImagesURL;
            break;
        case uploadCheckListsCode:
            parameters =@{@"uid":uid,@"token":token ,@"aid":para[@"aid"],@"qrBase64":para[@"qrBase64"]};
            URL = uploadCheckListsURL;
            break;
        default:
            break;
    }
    
    [[JiaoTongBuClient sharedClient] POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        callBack(0,dic,nil);
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callBack(1,nil,error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

@end
