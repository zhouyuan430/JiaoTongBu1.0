//
//  AssignmentCheckViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-10.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "ReadViewController.h"

@interface AssignmentCheckViewController : UITableViewController <getReaderViewDelegate>
{
    NSMutableArray *dataSource;
    
    NSMutableArray *isChecked;
    
    NSMutableArray *assetsPath;
    
    MBProgressHUD *HUD;
    
    MJRefreshHeaderView *_header;
}
@end
