//
//  PersonalAssetsViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetInfo.h"
#import "MBProgressHUD.h"
@interface PersonalAssetsViewController : UITableViewController <UITextFieldDelegate,UISearchBarDelegate>
{
    NSMutableArray *dataSource;
    AssetInfo *assetInfo;
    
    MBProgressHUD * HUD;
}

@property (nonatomic, retain) AssetInfo *assetInfo;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
