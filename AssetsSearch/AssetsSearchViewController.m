//
//  AssetsSearchViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-23.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetsSearchViewController.h"
#import "AssetInfo.h"
#import "TMDiskCache.h"
#import "JiaoTongBuClient.h"
#import "AssetCell.h"
#import "SearchDetailViewController.h"
@interface AssetsSearchViewController ()

@end

static NSString* const KAuthListPlist = @"AuthList.plist";

@implementation AssetsSearchViewController

@synthesize searchBarButton;

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
    [self.tableView removeObserver:_footer forKeyPath:@"contentOffset"];
    [self.tableView removeObserver:_footer forKeyPath:@"contentSize"];
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (searched) {
        [[TMDiskCache sharedCache] removeObjectForKey:KAuthListPlist];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addFooter];
    
    dataSource = [[NSMutableArray alloc] initWithCapacity:20];
    
    searched = NO;
    size = 20;
    
    //添加左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                   target:self
                                   action:@selector(ReplyButton)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    searchBarButton.showsCancelButton = YES;
    searchBarButton.delegate = self;
    
    [self getData:@"" searchItem:@""];
    [self.tableView reloadData];
}

-(IBAction)ReplyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

//获取数据
-(void)getData:(NSString *)keywd searchItem:(NSString *)Item
{
    [dataSource removeAllObjects];
   // [self.tableView reloadData];

    if ([[TMDiskCache sharedCache] objectForKey:KAuthListPlist]!= nil) {
        NSLog(@"本地");
        [self loadData:(NSDictionary *)[[TMDiskCache sharedCache] objectForKey:KAuthListPlist]];
    }
    else{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示

        NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
        NSString *token = [[UserDefaults userDefaults] getdata:kToken];
        
        NSDictionary *paramenters = @{@"uid":uid,@"token":token,@"keywd":keywd,
                                      @"searchItem":Item,@"page":@"1",@"size":[NSString stringWithFormat:@"%d",size]};
        
        [[JiaoTongBuClient sharedClient] GET:getAuthList parameters:paramenters success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
            
            NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
            if ([dic[@"status"] isEqualToString:@"A0006"])
            {
                //存储数据,历史缓存类型
                [[TMDiskCache sharedCache] setObject:dic forKey:KAuthListPlist];
                [self loadData:dic];
            }
            else{
                [self showMsg:dic[@"msg"]];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //显示

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [self showMsg:error.localizedDescription];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //显示

        }];
    }
}

-(void)loadData:(NSDictionary*)dic
{
    NSArray *arr = dic[@"data"];
    for (int i = 0 ; i < [arr count]; i++) {
        AssetInfo *tmp = [[AssetInfo alloc] initWithData:arr[i]];
        [dataSource addObject:tmp];
    }
    [self.tableView reloadData];
}

//弹出提示框
-(void)showMsg:(NSString*)msg
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = msg;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];
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
    static NSString *CellIdentifier = @"AuthCell";
    AssetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AssetInfo *tmp = dataSource[indexPath.row];
    cell.assetName.text = tmp.assetName;
    cell.assetKind.text = [NSString stringWithFormat:@"种类：%@",tmp.assetCate];
    cell.assetcount.text = [NSString stringWithFormat:@"数量：%@",tmp.assetCount];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.searchBarButton resignFirstResponder];
    UIViewController *view = segue.destinationViewController;
    if ([view respondsToSelector:@selector(setAssetInfo:)])
    {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        
        [view setValue:dataSource forKey:@"dataSource"];
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
    [[TMDiskCache sharedCache] removeObjectForKey:KAuthListPlist];
    searched = YES;
    [self getData:searchBar.text searchItem:@""];
    [searchBar resignFirstResponder];
}

//下拉加载更多
- (void)addFooter
{
    __unsafe_unretained AssetsSearchViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 增加5条假数据
        // 模拟延迟加载数据，因此2秒后才调用）
        [vc performSelector:@selector(PreviousView:) withObject:refreshView afterDelay:0.2];
    };
    _footer = footer;
}

- (void)PreviousView:(MJRefreshBaseView *)refreshView
{
    [[TMDiskCache sharedCache] removeObjectForKey:KAuthListPlist];
    size += 20;
    [self getData:searchBarButton.text searchItem:@""];
    [refreshView endRefreshing];
}



@end
