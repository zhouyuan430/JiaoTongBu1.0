//
//  ContactInfoViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-13.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "MessageBox.h"

@interface ContactInfoViewController : UITableViewController
{
    //提示框
    MessageBox * HHUD;
    
    //下拉刷新
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;

    BOOL getMore;
}
@property (strong,nonatomic) NSMutableArray *dataSource;

@end
