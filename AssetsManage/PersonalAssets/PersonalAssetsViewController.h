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
#import "MJRefresh.h"

@interface PersonalAssetsViewController : UITableViewController <UITextFieldDelegate,UISearchBarDelegate>
{
    NSMutableArray *dataSource;
    
    //判断是否经历过搜索
    BOOL searched;
    
    MBProgressHUD * HUD;
    
    MJRefreshHeaderView *_header;
}

@property (strong, nonatomic) IBOutlet UISearchBar *assetSearchBar;

@end
