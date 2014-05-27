//
//  AssetDirectCheck.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-24.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetDirectCheck.h"


@implementation AssetDirectCheck

@dynamic checkFlag;

-(void)initCheckData:(NSDictionary *)data
{
    if (data) {
        self.assetID = [NSNumber numberWithInt:[data[@"id"] integerValue]];
        self.assetName  = data[@"name"];
        self.assetCate  = data[@"cate"];
        self.assetCardID = data[@"cardid"];
        self.assetImgPath = data[@"assetImgPath"];
        self.checkFlag = 0;
    }
}

@end
