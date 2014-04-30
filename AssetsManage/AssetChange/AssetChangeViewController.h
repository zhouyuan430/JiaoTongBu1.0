//
//  AssetChangeViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-21.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface AssetChangeViewController : UITableViewController<UIAlertViewDelegate>
{
    NSMutableArray *dataSource;
    
    NSMutableArray *isSelected;
    MBProgressHUD * HUD;
}
@end
