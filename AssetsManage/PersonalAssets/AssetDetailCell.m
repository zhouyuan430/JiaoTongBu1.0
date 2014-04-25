//
//  AssetDetailCell.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetDetailCell.h"
#import "AssetImage.h"
@implementation AssetDetailCell

@synthesize assetImg;
@synthesize assetID;
@synthesize assetkind;
@synthesize assetName;
@synthesize assetImgUrl;
@synthesize userName;
@synthesize useDeadline;
@synthesize recentCheckDate;
@synthesize directorName;
@synthesize asserCount;

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

-(void)loadImg:(NSString *)_url
{
    if (_url) {
        AssetImage *img = [[AssetImage alloc] initWithFrame:CGRectMake(0,0,self.assetImg.frame.size.width,self.assetImg.frame.size.height)];
        [img loadimg:_url];
        [self.assetImg setImage:img.image forState:UIControlStateNormal];
    }
}

-(void)setdata:(AssetInfo *)tmp
{
    self.assetName.text = tmp.assetName;
    self.assetkind.text = [NSString stringWithFormat:@"种类：%@", tmp.assetCate];
    self.asserCount.text = [NSString stringWithFormat:@"数量：%@", tmp.assetCount];
    self.userName.text = [NSString stringWithFormat:@"使用人：%@", tmp.userName];
    self.directorName.text = [NSString stringWithFormat:@"监管部门：%@", tmp.directorName];
}
@end
