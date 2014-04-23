//
//  AssetInfo.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetInfo.h"

@implementation AssetInfo

@synthesize assetID;
@synthesize assetCount;
@synthesize assetName;
@synthesize assetCate;
@synthesize recentCheckDate;
@synthesize userName;
@synthesize directorName;
@synthesize useDeadline;
@synthesize assetImgUrl;
@synthesize assetImg;
@synthesize assetValue;

-(AssetInfo *)initWithData:(NSDictionary *)dic
{
    AssetInfo *tmp = [[AssetInfo alloc] init];
    tmp.assetID = dic[@"aid"];
    tmp.assetName = dic[@"name"];
    tmp.assetCate = dic[@"cate"];
    tmp.assetValue = dic[@"value"];
    tmp.userName = dic[@"username"];
    tmp.assetCount = dic[@"count"];
    tmp.directorName = dic[@"useDepartment"];
    
    return tmp;
}
@end
