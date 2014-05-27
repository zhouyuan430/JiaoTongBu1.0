//
//  AssetCheck.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-23.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetCheck.h"

@implementation AssetCheck

@dynamic checkFlag;

-(void)initCheckData:(NSDictionary *)data
{
    if (data) {
        self.assetID = [NSNumber numberWithInt:[data[@"id"] integerValue]];
        self.assetName = data[@"assetsName"];
        self.assetCate = data[@"name_assetsBudget"];
        self.assetValue = data[@"assetValue"];
        self.userName = data[@"username"];
        self.assetCount = data[@"num"];
        self.useDepartment = data[@"name_department"];
        self.assetCardID = data[@"assetsId"];
        self.assetImgPath = data[@"image"];
        self.checkFlag = 0;
    }
}

@end
