//
//  UpLoadImage.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-14.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "UpLoadImage.h"
#import "JiaoTongBuClient.h"
#import "TMDiskCache.h"
#import "AssetInfo.h"
#import "DiskCache.h"

@implementation UpLoadImage
static NSString* const KAssetsListPlist = @"AssetsList.plist";

-(void)upLoadImage:(NSData *)imageData viewController:(UITableViewController*)view info:(AssetInfo*)tmp
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示
    
    [HHUD showWait:@"正在上传图片..." viewController:view];
    
    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    
    NSString *imageString = [imageData base64Encoding];
    
    
    NSDictionary *parameters =@{@"base64":imageString,@"uid":uid,@"token":token ,@"aid":tmp.assetID};
    [[JiaoTongBuClient sharedClient] POST:uploadAssetImages parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        
        tmp.assetImgPath = [NSString stringWithFormat:@"%@",tmp.assetCardID];
        NSString *key = [NSString stringWithFormat:@"http://%@",tmp.assetImgPath];
        [[DiskCache sharedSearchCateLoad] storeData:imageData forKey:key];
        
        [[TMDiskCache sharedCache] removeObjectForKey:KAssetsListPlist];

        [HHUD showHide:view];
        [HHUD showMsg:dic[@"msg"] viewController:view];
        
        [view.tableView reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [HHUD showHide:view];
        [HHUD showMsg:error.localizedDescription viewController:view];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}



@end
