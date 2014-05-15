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
@synthesize assetImgPath;
@synthesize assetImg;
@synthesize assetValue;
@synthesize assetCardID;
@synthesize upLoadPath;

-(AssetInfo *)initWithData:(NSDictionary *)dic
{
    AssetInfo *tmp = [[AssetInfo alloc] init];
    if (dic) {
        tmp.assetID = dic[@"aid"];
        tmp.assetName = dic[@"name"];
        tmp.assetCate = dic[@"cate"];
        tmp.assetValue = dic[@"value"];
        tmp.userName = dic[@"username"];
        tmp.assetCount = dic[@"count"];
        tmp.directorName = dic[@"useDepartment"];
        tmp.assetCardID = dic[@"assetCardId"];
        tmp.assetImgPath = dic[@"image"];
    }
    return tmp;
}

-(AssetInfo *)initWithCheckData:(NSDictionary *)dic
{
    AssetInfo *tmp = [[AssetInfo alloc] init];
    if (dic) {
        tmp.assetID = dic[@"id"];
        tmp.assetName = dic[@"assetsName"];
        tmp.assetCate = dic[@"name_assetsBudget"];
        tmp.assetValue = dic[@"assetValue"];
        tmp.userName = dic[@"username"];
        tmp.assetCount = dic[@"num"];
        tmp.directorName = dic[@"name_department"];
        tmp.assetCardID = dic[@"assetsId"];
        tmp.assetImgPath = dic[@"image"];
    }
    return tmp;
}
@end
