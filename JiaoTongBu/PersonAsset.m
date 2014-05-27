//
//  DataSource.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-22.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "PersonAsset.h"


@implementation PersonAsset

@dynamic assetCardID;
@dynamic assetCate;
@dynamic assetCount;
@dynamic assetID;
@dynamic assetImgPath;
@dynamic assetName;
@dynamic assetValue;
@dynamic id_useOffice;
@dynamic upLoadPath;
@dynamic useDepartment;
@dynamic useOffice;
@dynamic userName;

-(void)initWithData:(NSDictionary *)data
{
    if (data) {
        self.assetID = [NSNumber numberWithInt:[data[@"aid"] integerValue]];
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
