//
//  AssetsSearchViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-23.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetsSearchViewController.h"
#import "JiaoTongBuClient.h"
#import "AssetCell.h"
#import "SearchDetailViewController.h"
#import "CommentData.h"
#import "AuthAsset.h"

@interface AssetsSearchViewController ()

@end

static int page = 1;

@implementation AssetsSearchViewController

@synthesize dataSource = _dataSource;
@synthesize searchBarButton;
@synthesize searchItemBt;
@synthesize MyTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [self.MyTableView removeObserver:_footer forKeyPath:@"contentOffset"];
    [self.MyTableView removeObserver:_footer forKeyPath:@"contentSize"];
    [self.MyTableView removeObserver:_header forKeyPath:@"contentOffset"];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:1 alpha:1]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.MyTableView setFrame:CGRectMake(44,5, 320, 400)];
}
-(void)viewDidDisappear:(BOOL)animated
{
    if (searched) {
        [[CommentData sharedInstance] delete:KAuthAssetName entityName:KAuthAssetCode];
    }
}

-(void)initData
{
    HHUD = [[MessageBox alloc] init];
    
    [self addFooter];
    [self addHeader];
    
    searchItermArr = [[NSMutableArray alloc] initWithObjects:@"名称",@"使用人",@"处室",@"类别", nil];
    
    searched = NO;
    getMore = NO;
    

    [self.MyTableView setContentInset:UIEdgeInsetsMake(44, 0, 64, 0)];
    self.MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(IBAction)searchItemBt:(id)sender
{
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    [self initData];
    
    [self.navigationItem setBackItemWithTarget:self action:@selector(replyButton)];
        
    [self getData:@"" searchItem:@""];
}

-(IBAction)replyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
//获取数据
-(void)getData:(NSString *)keywd searchItem:(NSString *)Item
{
    [self.dataSource removeAllObjects];
    if (getMore) {
        [self connect:keywd searchItem:Item];
        getMore = NO;
    }
    else if ([[CommentData sharedInstance] getData:KAuthAssetName].count != 0) {
        self.dataSource = [[CommentData sharedInstance] getData:KAuthAssetName];
    }
    else{
        [self connect:keywd searchItem:Item];
    }
}

-(void)connect:(NSString *)keywd searchItem:(NSString *)Item
{
    NSDictionary *para = @{@"keywd":keywd,
                           @"Item":Item,
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"size":@"10"};
    [[JiaoTongBuClient sharedClient] startGet:getAuthListCode parameters:para withCallBack:^(int flag, NSDictionary *dic, NSError *error) {
        if (flag == 0) {
            [self loadData:dic];
        }
        else if(flag == 1){
            self.dataSource = [[CommentData sharedInstance] getData:KAuthAssetName];
            [HHUD showMsg:KNoMoreData viewController:self];
            [self.MyTableView reloadData];
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
        [[CommentData sharedInstance] insertData:arr[i] entityName:KAuthAssetCode];
    }
    self.dataSource = [[CommentData sharedInstance] getData:KAuthAssetName];
    [self.MyTableView reloadData];
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
    static NSString *CellIdentifier = @"AuthCell";
    AssetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    
    if(indexPath.row < self.dataSource.count)
    {
        AuthAsset *tmp = self.dataSource[indexPath.row];
        [cell loadimg:tmp.assetImgPath];
        cell.assetName.text = tmp.assetName;
        cell.assetKind.text = [NSString stringWithFormat:@"类型：%@",tmp.assetCate];
        cell.assetCardID.text = [NSString stringWithFormat:@"固定资产编号：%@",tmp.assetCardID];
    }
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.searchBarButton resignFirstResponder];
    UIViewController *view = segue.destinationViewController;
    if ([view respondsToSelector:@selector(setCurrentInfo:)])
    {
        NSIndexPath *selectedRowIndex = [self.MyTableView indexPathForSelectedRow];
        [view setValue:self.dataSource forKey:@"dataSource"];
        [view setValue:selectedRowIndex forKey:@"currentInfo"];
    }
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
    [[CommentData sharedInstance] delete:KAuthAssetName entityName:KAuthAssetCode];
    searched = YES;
    [self getData:searchBar.text searchItem:searchItemBt.titleLabel.text];
    [searchBar resignFirstResponder];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.layer.zPosition = 1;

    searchBar.showsScopeBar = YES;
    [self.MyTableView setContentInset:UIEdgeInsetsMake(88, 0, 0, 0)];
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsScopeBar = NO;
    [self.MyTableView setContentInset:UIEdgeInsetsMake(44, 0, 0, 0)];

    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [searchItemBt setTitle:searchItermArr[selectedScope] forState:UIControlStateNormal];
}



//上拉加载更多
- (void)addFooter
{
    __unsafe_unretained AssetsSearchViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.MyTableView;
    
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 增加5条假数据
        // 模拟延迟加载数据，因此0.2秒后才调用）
        [vc performSelector:@selector(PreviousView:) withObject:refreshView afterDelay:0.2];
    };
    _footer = footer;
}
//下拉加载
- (void)addHeader
{
    __unsafe_unretained AssetsSearchViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.MyTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        // 模拟延迟加载数据，因此0.2秒后才调用）
        [vc performSelector:@selector(NextView:) withObject:refreshView afterDelay:0.2];
    };
    _header = header;
}


- (void)PreviousView:(MJRefreshBaseView *)refreshView
{
    getMore = YES;
    page ++;
    [self getData:searchBarButton.text searchItem:searchItemBt.titleLabel.text];
    [refreshView endRefreshing];
}

- (void)NextView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [[CommentData sharedInstance] delete:KAuthAssetName entityName:KAuthAssetCode];
    page = 1;
    [self getData:searchBarButton.text searchItem:searchItemBt.titleLabel.text];
    [refreshView endRefreshing];
}



@end
