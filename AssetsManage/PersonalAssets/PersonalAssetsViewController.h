//
//  PersonalAssetsViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetInfo.h"
@interface PersonalAssetsViewController : UITableViewController
{
    NSMutableArray *dataSource;
    AssetInfo *assetInfo;
}

@property (nonatomic, retain) AssetInfo *assetInfo;
@end
