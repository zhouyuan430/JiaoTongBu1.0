//
//  ContactInfoViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-13.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface ContactInfoViewController : UITableViewController
{
    //数据源
    NSMutableArray * dataSource;
    //提示框
    MBProgressHUD * HUD;
    //下拉刷新
    MJRefreshHeaderView *_header;
}


@end
