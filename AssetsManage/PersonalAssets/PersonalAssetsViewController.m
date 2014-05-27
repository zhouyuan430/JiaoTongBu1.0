//
//  PersonalAssetsViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//
#import "PersonalAssetsViewController.h"
#import "AssetCell.h"
#import "AssetDetailViewController.h"
#import "JiaoTongBuClient.h"
#import "CommentData.h"
#import "PersonAsset.h"

@interface PersonalAssetsViewController ()

@end

@implementation PersonalAssetsViewController
@synthesize assetSearchBar;
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
    [self.tableView removeObserver:_footer forKeyPath:@"contentSize" ];
    [self.tableView removeObserver:_footer forKeyPath:@"contentOffset"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:1 alpha:1]];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (searched) {
        [[CommentData sharedInstance] delete:KPersonAssetName entityName:KPersonAssetCode];
    }
}


-(void)initData
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    HHUD = [[MessageBox alloc] init];

    [self addHeader];
    [self addFooter];
    
    searched = NO;
    getMore = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    self.title = [NSString stringWithFormat:@"资产[%@]",[[UserDefaults userDefaults] getdata:kUserName]];
    
    [self.navigationItem setBackItemWithTarget:self action:@selector(replyButton)];

    assetSearchBar.showsCancelButton = YES;
    [self getData:@""];
    [self.tableView reloadData];
}

//返回上级界面
-(void)replyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)connect:(NSString *)keywd
{
    NSDictionary *para = @{@"page":[NSString stringWithFormat:@"%d",page],@"size":@"10",@"keywd":keywd};
    [[JiaoTongBuClient sharedClient] startGet:getAssetPageListCode parameters:para withCallBack:^(int flag, NSDictionary *dic,NSError *error) {
        if (flag == 0) {
            [self loadData:dic];
        }
        else if (flag == 1){
            [HHUD showMsg:KNoMoreData viewController:self];
        }
        else{
            [HHUD showMsg:error.localizedDescription viewController:self];
        }
    }];
}

-(void)getData:(NSString *)keywd
{
    [self.dataSource removeAllObjects];
    
    if (getMore) {
        [self connect:keywd];
        getMore = NO;
    }
    if ([[CommentData sharedInstance] getData:KPersonAssetName].count != 0) {
        self.dataSource = [[CommentData sharedInstance] getData:KPersonAssetName];
    }
    else{
        [self connect:keywd];
    }
}

-(void)loadData:(NSDictionary *)dic
{
    NSArray *arr = dic[@"data"];
    for (int i = 0 ; i < [arr count]; i++) {
        [[CommentData sharedInstance] insertData:arr[i] entityName:KPersonAssetCode];
    }
    
    self.dataSource = [[CommentData sharedInstance] getData:KPersonAssetName];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PersonalAssetCell";
    AssetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
          cell = [[AssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row%2 == 0) {
        UIImageView *tt = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonAssetBG-0"]];
        [cell setBackgroundView:tt];
    }
    else{
        UIImageView *tt = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonAssetBG-1"]];
        [cell setBackgroundView:tt];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    if (indexPath.row < self.dataSource.count) {
        PersonAsset *tmp = self.dataSource[indexPath.row];
        
        cell.assetName.text = tmp.assetName;
        cell.assetKind.text = [NSString stringWithFormat:@"类型：%@",tmp.assetCate];
        cell.assetCardID.text = [NSString stringWithFormat:@"固定资产编号：%@",tmp.assetCardID];
        
        [cell loadimg:tmp.assetImgPath];
    }
    // Configure the cell...
    
    return cell;
}


#pragma mark - SearchBar


//点击取消按钮时，隐藏键盘
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}
//点击搜索按钮时，隐藏键盘，显示搜索内容
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [[CommentData sharedInstance] delete:KPersonAssetName entityName:KPersonAssetCode];
    searched = YES;
    [self getData:searchBar.text];
    [searchBar resignFirstResponder];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [assetSearchBar resignFirstResponder];
    UIViewController *view = segue.destinationViewController;
    if ([view respondsToSelector:@selector(setCurrentInfo:)])
    {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        //传递数据
        [view setValue:self.dataSource forKey:@"dataSource"];
        [view setValue:selectedRowIndex forKey:@"currentInfo"];
    }
}

#pragma 下拉刷新
- (void)addHeader
{
    __unsafe_unretained PersonalAssetsViewController *vc = self;
    
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
    [[CommentData sharedInstance] delete:KPersonAssetName entityName:KPersonAssetCode];
    
    page = 1;
    [self getData:assetSearchBar.text];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}


#pragma 上拉加载
- (void)addFooter
{
    __unsafe_unretained PersonalAssetsViewController *vc = self;
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
    page ++;
    [self getData:assetSearchBar.text];
    [refreshView endRefreshing];
}


@end
