//
//  AssetsSearchViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-23.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBox.h"
#import "MJRefresh.h"

@interface AssetsSearchViewController : UIViewController <UITextFieldDelegate,UISearchBarDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
{    
    NSMutableArray * searchItermArr;
    //判断是否经历过搜索
    BOOL searched;
    BOOL getMore;
    
    MessageBox * HHUD;
    //上拉加载更多
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@property (strong,nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBarButton;
@property (strong, nonatomic) IBOutlet UITableView *MyTableView;

@property (strong, nonatomic) IBOutlet UIButton *searchItemBt;

-(IBAction)searchItemBt:(id)sender;

@end
