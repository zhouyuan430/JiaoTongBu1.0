//
//  AssetChangeViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-21.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"
@interface AssetChangeViewController : UITableViewController<UIAlertViewDelegate>
{
    //数据源
    NSMutableArray *dataSource;
    //选中框
    NSMutableArray *isSelected;
    //提示框
    MBProgressHUD * HUD;
    //下拉刷新
    MJRefreshHeaderView *_header;
}
@end
