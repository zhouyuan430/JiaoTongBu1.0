//
//  AuthAsset.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-23.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AuthAsset.h"


@implementation AuthAsset

@dynamic assetID;
@dynamic assetName;
@dynamic assetCate;
@dynamic assetValue;
@dynamic userName;
@dynamic assetCount;
@dynamic useDepartment;
@dynamic assetCardID;
@dynamic assetImgPath;
@dynamic useOffice;
@dynamic id_useOffice;
@dynamic upLoadPath;

-(void)initWithData:(NSDictionary *)data
{
    if (data) {
        self.assetID = [NSNumber numberWithInt:[data[@"aid"] intValue]];
        self.assetName = data[@"name"];
        self.assetCate = data[@"cate"];
        self.assetValue = data[@"value"];
        self.userName = data[@"username"];
        self.assetCount = data[@"count"];
        self.useDepartment = data[@"useDepartment"];
        self.assetCardID = data[@"assetCardId"];
        self.assetImgPath = data[@"image"];
        self.useOffice = data[@"useOffice"];
        self.id_useOffice = data[@"id_useOffice"];
    }
}

@end
