//
//  JiaoTongBuClient.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-20.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "JiaoTongBuClient.h"
#import "GDataXMLNode.h"
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

@end
