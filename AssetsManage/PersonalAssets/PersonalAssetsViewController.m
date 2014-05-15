//
//  PersonalAssetsViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//
#import "PersonalAssetsViewController.h"
#import "AssetCell.h"
#import "AssetInfo.h"
#import "TMDiskCache.h"
#import "AssetDetailViewController.h"
#import "JiaoTongBuClient.h"
@interface PersonalAssetsViewController ()

@end

static NSString* const KAssetsListPlist = @"AssetsList.plist";

@implementation PersonalAssetsViewController
@synthesize assetSearchBar;

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
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (searched) {
        [[TMDiskCache sharedCache] removeObjectForKey:KAssetsListPlist];
    }
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self getData:@""];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HHUD = [[MessageBox alloc] init];
   // self.navigationController.delegate = self;
    
    [self addHeader];
    searched = NO;
    dataSource = [[NSMutableArray alloc] initWithCapacity:20];
    
    self.title = [NSString stringWithFormat:@"资产[%@]",[[UserDefaults userDefaults] getdata:kUserName]];
    
    //添加左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                   target:self
                                   action:@selector(replyButton)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    assetSearchBar.showsCancelButton = YES;
    [self getData:@""];
    [self.tableView reloadData];
}

//返回上级界面
-(void)replyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData:(NSString *)keywd
{
    [dataSource removeAllObjects];
    [self.tableView reloadData];

    if ([[TMDiskCache sharedCache] objectForKey:KAssetsListPlist] != nil) {
        NSLog(@"本地");
        [self loadData:(NSDictionary *)[[TMDiskCache sharedCache] objectForKey:KAssetsListPlist]];
    }
    else{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
        NSString *token = [[UserDefaults userDefaults] getdata:kToken];
        
        NSDictionary *parameters = @{@"uid":uid,@"keywd":keywd,@"token":token};
        
        [[JiaoTongBuClient sharedClient] GET:getAssetsList parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
            
            NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
            if ([dic[@"status"] isEqualToString:@"A0006"])
            {
                //存储数据,历史缓存类型
                [[TMDiskCache sharedCache] setObject:dic forKey:KAssetsListPlist];
                [self loadData:dic];
            }
            else{
                [HHUD showMsg:dic[@"msg"] viewController:self];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //隐藏

    }
}

-(void)loadData:(NSDictionary *)dic
{
    NSArray *arr = dic[@"data"];
    for (int i = 0 ; i < [arr count]; i++) {
        AssetInfo *tmp = [[AssetInfo alloc] initWithData:arr[i]];
        [dataSource addObject:tmp];
    }
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
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PersonalAssetCell";
    AssetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
          cell = [[AssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < dataSource.count) {
        AssetInfo *tmp = dataSource[indexPath.row];
        [cell setData:tmp];
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
    [[TMDiskCache sharedCache] removeObjectForKey:KAssetsListPlist];
    searched = YES;
    [self searchBarCancelButtonClicked:searchBar];

    [self getData:searchBar.text];

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
        [view setValue:dataSource forKey:@"dataSource"];
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
    [[TMDiskCache sharedCache] removeObjectForKey:KAssetsListPlist];
    [self getData:assetSearchBar.text];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}



@end
