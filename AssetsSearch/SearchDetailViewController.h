//
//  SearchDetailViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-24.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "AssetInfo.h"
@interface SearchDetailViewController : UITableViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
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

@property (strong, nonatomic) NSIndexPath *currentInfo;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) AssetInfo *assetInfo;

-(IBAction)imgClick:(id)sender;

@end
