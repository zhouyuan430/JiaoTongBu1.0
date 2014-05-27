//
//  PersonalAssetsViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBox.h"
#import "MJRefresh.h"

@interface PersonalAssetsViewController : UITableViewController <UITextFieldDelegate,UISearchBarDelegate,UINavigationControllerDelegate>
{
    MessageBox *HHUD;
    
    BOOL getMore;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}

@property (strong,nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) IBOutlet UISearchBar *assetSearchBar;

@end
