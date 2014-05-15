//
//  AssetCell.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetCell.h"
#import "AssetImage.h"
@implementation AssetCell

@synthesize assetName;
@synthesize assetKind;
@synthesize assetcount;
@synthesize assetImg;

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

-(void)loadimg:(NSString *)_url
{
    AssetImage *img = [[AssetImage alloc] initWithFrame:CGRectMake(0, 0, self.assetImg.frame.size.width, self.assetImg.frame.size.height)];
    if ([_url isEqualToString:@""]) {
        img.image = [UIImage imageNamed:@"Icon"];
    }
    else{
        [img loadimg:_url];
        if (!img.image) {
            img.image = [UIImage imageNamed:@"Icon"];
        }
    }
    [self.assetImg addSubview:img];
}
-(void)setData:(AssetInfo *)tmp
{
    if (tmp) {
        self.assetName.text = tmp.assetName;
        self.assetKind.text = [NSString stringWithFormat:@"类型：%@",tmp.assetCate];
        self.assetcount.text = [NSString stringWithFormat:@"固定资产编号：%@",tmp.assetCardID];
    }
}

@end
