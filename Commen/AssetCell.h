//
//  AssetCell.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetInfo.h"
@interface AssetCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *assetName;
@property (strong, nonatomic) IBOutlet UILabel *assetKind;
@property (strong, nonatomic) IBOutlet UILabel *assetcount;

-(void)setData:(AssetInfo *)tmp;

@end
