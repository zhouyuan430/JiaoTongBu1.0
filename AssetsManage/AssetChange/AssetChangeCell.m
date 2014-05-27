//
//  AssetChangeCell.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-21.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetChangeCell.h"

@implementation AssetChangeCell

@synthesize CheckButton;

-(void)setData:(AssetChange *)tmp
{
    if (tmp) {
        self.assetName.text = tmp.assetName;
        self.assetKind.text = [NSString stringWithFormat:@"类型：%@",tmp.assetCate];
        self.assetcount.text = [NSString stringWithFormat:@"固定资产编号：%@",tmp.assetCardID];
        self.assetCardID.text = [NSString stringWithFormat:@"固定资产编号：%@",tmp.assetCardID];
    }
}

@end
