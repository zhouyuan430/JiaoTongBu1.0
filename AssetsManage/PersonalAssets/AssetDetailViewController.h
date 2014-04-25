//
//  AssetDetailViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "AssetInfo.h"
#import "MBProgressHUD.h"
@interface AssetDetailViewController : UITableViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    MBProgressHUD *HUD;
    
    NSMutableArray *dataSource;
    //图片选择器
    UIActionSheet *myActionSheet;
    
    //图片2进制路径
    NSString* filePath;
    
    //下拉和上拉
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    NSUInteger currentLine;
}
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSIndexPath *currentInfo;
@property (strong, nonatomic) AssetInfo *assetInfo;
-(IBAction)imgClick:(id)sender;
@end
