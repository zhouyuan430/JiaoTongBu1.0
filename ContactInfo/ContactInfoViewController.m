//
//  ContactInfoViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-13.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "ContactInfoViewController.h"
#import "JiaoTongBuClient.h"
#import "ServerAddr.h"
#import "ContactInfo.h"
#import "ContactInfoCell.h"
#import "CommentData.h"

@interface ContactInfoViewController ()

@end

@implementation ContactInfoViewController

@synthesize dataSource = _dataSource;
static int page = 1;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [self.tableView removeObserver:_header forKeyPath:@"contentOffset"];
    [self.tableView removeObserver:_footer forKeyPath:@"contentSize"];
    [self.tableView removeObserver:_footer forKeyPath:@"contentOffset"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:1 alpha:1]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    HHUD = [[MessageBox alloc] init];
    
    getMore = NO;
    [self addHeader];
    [self addFooter];
    
    [self.navigationItem setBackItemWithTarget:self action:@selector(replyButton)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getData];
}
//返回上一级
-(IBAction)replyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
//获取数据
-(void)getData
{
    [self.dataSource removeAllObjects];
    if (getMore) {
        [self connect];
        getMore = NO;
    }
    else if ([[CommentData sharedInstance] getData:KContactInfoName].count != 0) {
        self.dataSource = [[CommentData sharedInstance] getData:KContactInfoName];
    }
    else{
        [self connect];
    }
}

-(void)connect
{
    NSDictionary *para = @{@"page":[NSString stringWithFormat:@"%d",page],@"size":[NSString stringWithFormat:@"3"]};

    [[JiaoTongBuClient sharedClient] startGet:getContactPageListCode parameters:para withCallBack:^(int successed, NSDictionary *dic,NSError *error) {
        if (successed == 0) {
            [self loadData:dic];
        }
        else if(successed == 1){
            page --;
            [HHUD showMsg:KNoMoreData viewController:self];
            self.dataSource = [[CommentData sharedInstance] getData:KContactInfoName];
            [self.tableView reloadData];
        }
        else{
            [HHUD showMsg:error.localizedDescription viewController:self];
        }
    }];
}

-(void)loadData:(NSDictionary*)dic
{

    NSArray *arr = dic[@"data"];
    for (int i = 0 ; i < [arr count]; i++) {
        [[CommentData sharedInstance] insertData:arr[i] entityName:KContactInfoCode];
    }
    self.dataSource = [[CommentData sharedInstance] getData:KContactInfoName];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactInfoCell";
    ContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[ContactInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row < self.dataSource.count) {
        if (indexPath.row %2 == 0) {
            UIImageView *tt = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonAssetBG-0"]];
            [cell setBackgroundView:tt];
        }
        else{
            UIImageView *tt = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonAssetBG-1"]];
            [cell setBackgroundView:tt];
        }
    
        // Configure the cell...
        ContactInfo *tmp = self.dataSource[indexPath.row];
        [cell setCellInfo:tmp];
    }
    return cell;
}

#pragma 下拉刷新
- (void)addHeader
{
    __unsafe_unretained ContactInfoViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        // 模拟延迟加载数据，因此0.2秒后才调用
        [vc performSelector:@selector(NextView:) withObject:refreshView afterDelay:0.2];
        
    };
    _header = header;
}

- (void)NextView:(MJRefreshBaseView *)refreshView
{
    [[CommentData sharedInstance] delete:KContactInfoName entityName:KContactInfoCode];
    
    page = 1;
    [self getData];
    //结束刷新状态
    [refreshView endRefreshing];
}

#pragma 上拉加载

- (void)addFooter
{
    __unsafe_unretained ContactInfoViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 模拟延迟加载数据，因此0.2秒后才调用）
        [vc performSelector:@selector(PreviousView:) withObject:refreshView afterDelay:0.2];
    };
    _footer = footer;
}
- (void)PreviousView:(MJRefreshBaseView *)refreshView
{
    getMore = YES;
    page ++ ;
    [self getData];
    [refreshView endRefreshing];
}


@end
