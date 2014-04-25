//
//  AssetDetailCell.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetInfo.h"
@interface AssetDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *assetImg;
@property (strong, nonatomic) NSString *assetID;
@property(strong, nonatomic) IBOutlet UILabel *asserCount;
@property (strong, nonatomic) IBOutlet UILabel *assetName;
@property (strong, nonatomic) IBOutlet UILabel *assetkind;
@property (strong, nonatomic) IBOutlet UILabel *recentCheckDate;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *directorName;
@property (strong, nonatomic) IBOutlet UILabel *useDeadline;
@property (strong, nonatomic) NSString *assetImgUrl;

-(void)loadImg:(NSString *)_url;
-(void)setdata:(AssetInfo *)tmp;

@end
