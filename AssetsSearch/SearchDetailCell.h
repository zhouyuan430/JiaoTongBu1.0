//
//  SearchDetailCell.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-24.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetInfo.h"

@interface SearchDetailCell : UITableViewCell


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

-(void)loadImgDetail:(NSString *)_url;

-(void)setData:(AssetInfo *)tmp;


@end
