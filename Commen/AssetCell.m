//
//  AssetCell.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetCell.h"

@implementation AssetCell

@synthesize assetName;
@synthesize assetKind;
@synthesize assetcount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setData:(AssetInfo *)tmp
{
    if (tmp) {
        self.assetName.text = tmp.assetName;
        self.assetKind.text = [NSString stringWithFormat:@"种类：%@",tmp.assetCate];
        self.assetcount.text = [NSString stringWithFormat:@"数量：%@",tmp.assetCount];
    }
}

@end
