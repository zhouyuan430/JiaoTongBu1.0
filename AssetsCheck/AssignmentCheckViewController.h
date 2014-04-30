//
//  AssignmentCheckViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-10.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ZBarSDK.h"
#import "MJRefresh.h"
@interface AssignmentCheckViewController : UITableViewController <ZBarReaderDelegate>
{
    NSMutableArray *dataSource;
    
    NSMutableArray *isChecked;
    
    NSMutableArray *assetsPath;
    
    MBProgressHUD *HUD;
    
    MJRefreshHeaderView *_header;
}
@end
