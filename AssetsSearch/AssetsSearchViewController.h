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
#import "MJRefresh.h"

@interface AssetsSearchViewController : UITableViewController <UITextFieldDelegate,UISearchBarDelegate>
{
    NSMutableArray * dataSource;
    
    //判断是否经历过搜索
    BOOL searched;

    NSInteger size;
    
    MBProgressHUD * HUD;
    //上拉加载更多
    MJRefreshFooterView *_footer;

}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarButton;

@end
