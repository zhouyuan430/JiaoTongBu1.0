//
//  ContactInfoViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-13.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ContactInfoViewController : UITableViewController
{
    NSMutableArray * dataSource;
    
    MBProgressHUD * HUD;
}


@end
