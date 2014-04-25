//
//  AssetsSearchViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-23.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AssetInfo.h"
@interface AssetsSearchViewController : UITableViewController
{
    NSMutableArray * dataSource;
    
    MBProgressHUD * HUD;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@end
