//
//  AssetsSearchViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-23.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBox.h"
#import "AssetInfo.h"
#import "MJRefresh.h"
#import "CloCombox.h"

@interface AssetsSearchViewController : UITableViewController <UITextFieldDelegate,UISearchBarDelegate,UIAlertViewDelegate,CloComboxDelegate>
{
    NSMutableArray * dataSource;
    
    NSMutableArray * searchItermArr;
    //判断是否经历过搜索
    BOOL searched;
    int size;
    MessageBox * HHUD;
    //上拉加载更多
    MJRefreshFooterView *_footer;
    
    MJRefreshHeaderView *_header;
    CloCombox *comBox;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarButton;

@end
