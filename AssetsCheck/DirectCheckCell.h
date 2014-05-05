//
//  DirectCheckCell.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-25.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetCell.h"

@interface DirectCheckCell : AssetCell

@property (strong, nonatomic) IBOutlet UIButton *isCheckButton;

@property (strong, nonatomic) IBOutlet UIImageView * img;

@property (strong, nonatomic) IBOutlet UILabel *assetName;

@end
