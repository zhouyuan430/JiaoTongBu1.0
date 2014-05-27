//
//  AssetChangeViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-21.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBox.h"
#import "MJRefresh.h"
@interface AssetChangeViewController : UITableViewController<UIAlertViewDelegate>
{
    //提示框
    MessageBox * HHUD;
    //下拉刷新
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    BOOL getMore;
}
//数据源
@property (strong,nonatomic) NSMutableArray *dataSource;

-(IBAction)selectButton:(id)sender;

@end
