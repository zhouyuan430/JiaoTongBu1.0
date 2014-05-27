//
//  AssetDetailCell.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonAsset.h"
@interface AssetDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *assetImg;
@property (strong, nonatomic) IBOutlet UILabel *assetID;
@property (strong, nonatomic) IBOutlet UILabel *asserCount;
@property (strong, nonatomic) IBOutlet UILabel *assetName;
@property (strong, nonatomic) IBOutlet UILabel *assetkind;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *useDepartment;
@property (strong, nonatomic) IBOutlet UILabel *assetCardID;
@property (strong, nonatomic) IBOutlet UILabel *useOffice;
@property (strong, nonatomic) IBOutlet UILabel *id_useOffice;
@property (strong, nonatomic) IBOutlet UILabel *assetValue;

-(void)loadImgDetail:(NSString *)_url;

-(void)setdata:(PersonAsset *)tmp;

@end
