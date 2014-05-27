//
//  AssignmentCheckViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-10.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBox.h"
#import "MJRefresh.h"
#import "ReadViewController.h"
#import "ZBarSDK.h"

@interface AssignmentCheckViewController : UITableViewController <getReaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    int submitCount;
    int checkedCount;
    int unCheckedCount;
    
    BOOL getMore;
    //NSMutableArray *assetsPath;
    
    MessageBox *HHUD;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
}

@property (strong,nonatomic) NSMutableArray *dataSource;

@end
