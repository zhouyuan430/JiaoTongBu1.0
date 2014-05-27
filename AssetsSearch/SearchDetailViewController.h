//
//  SearchDetailViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-24.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "MessageBox.h"
@interface SearchDetailViewController : UITableViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *dataSource;
    //图片选择器
    UIActionSheet *myActionSheet;
    
    //下拉和上拉
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    MessageBox *HHUD;
    
    NSUInteger currentLine;
}

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSIndexPath *currentInfo;

-(IBAction)imgClick:(id)sender;

@end
