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
#import "ZBarSDK.h"

@interface AssignmentCheckViewController : UITableViewController <getReaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *dataSource;
    
    NSMutableArray *isChecked;
    
    int submitCount;
    
    int checkedCount;
    
    int unCheckedCount;
    //NSMutableArray *assetsPath;
    
    MBProgressHUD *HUD;
    
    MJRefreshHeaderView *_header;
    
}
@end
