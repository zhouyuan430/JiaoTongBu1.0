//
//  AssetChange.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-22.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetChange.h"


@implementation AssetChange

@dynamic assetID;
@dynamic assetCardID;
@dynamic assetCate;
@dynamic assetImgPath;
@dynamic assetName;
@dynamic isChecked;


-(void)initWithData:(NSDictionary *)data
{
    if (data) {
        self.assetID = [NSNumber numberWithInt:[data[@"aid"] intValue]];
        self.assetName = data[@"name"];
        self.assetCate = data[@"cate"];
        self.assetCardID = data[@"assetCardId"];
        self.assetImgPath = data[@"image"];
        self.isChecked = 0;
    }
}
@end
