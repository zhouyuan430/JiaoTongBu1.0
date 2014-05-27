//
//  SearchDetailCell.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-24.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "SearchDetailCell.h"
#import "AssetImage.h"
#import "AuthAsset.h"
@implementation SearchDetailCell

@synthesize assetImg;
@synthesize assetID;
@synthesize assetkind;
@synthesize assetName;
@synthesize userName;
@synthesize useDepartment;
@synthesize asserCount;
@synthesize assetCardID;
@synthesize useOffice;
@synthesize id_useOffice;
@synthesize assetValue;

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

-(void)loadImgDetail:(NSString *)_url
{
    AssetImage *img = [[AssetImage alloc] initWithFrame:CGRectMake(0,0,self.assetImg.frame.size.width,self.assetImg.frame.size.height)];
    if ([_url isEqualToString:@""]) {
        img.image = [UIImage imageNamed:@"DefaultAssetImg"];
    }
    else{
        [img loadimg:_url];
        if (!img.image) {
            img.image = [UIImage imageNamed:@"DefaultAssetImg"];
        }
    }
    [self.assetImg addSubview:img];
}

-(void)setData:(AuthAsset *)tmp
{
    self.assetName.text = tmp.assetName;
    self.assetCardID.text = [NSString stringWithFormat:@"固定资产编号：%@",tmp.assetCardID];
    self.assetID.text = [NSString stringWithFormat:@"编号：%@",tmp.assetID];
    self.assetkind.text = [NSString stringWithFormat:@"类别：%@",tmp.assetCate];
    self.userName.text = [NSString stringWithFormat:@"使用人：%@",tmp.userName];
    self.useDepartment.text = [NSString stringWithFormat:@"使用部门：%@", tmp.useDepartment];
    self.useOffice.text = [NSString stringWithFormat:@"使用处室：%@",tmp.useOffice];
    self.id_useOffice.text = [NSString stringWithFormat:@"处室编号：%@",tmp.id_useOffice];
    self.assetValue.text =[NSString stringWithFormat:@"价值：%@",tmp.assetValue];
    self.asserCount.text = [NSString stringWithFormat:@"数量：%@", tmp.assetCount];
}

@end
