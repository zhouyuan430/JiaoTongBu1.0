//
//  AssetChangeViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-21.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetChangeViewController.h"
#import "AssetChangeCell.h"
#import "JiaoTongBuClient.h"
#import "CommentData.h"
#import "AssetChange.h"

@interface AssetChangeViewController ()

@end

static int page = 1;

@implementation AssetChangeViewController

@synthesize dataSource = _dataSource;

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
    [self.tableView removeObserver:_footer forKeyPath:@"contentOffset"];
    [self.tableView removeObserver:_footer forKeyPath:@"contentSize"];
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
    //添加下拉刷新
    [self addHeader];
    [self addFooter];
    
    self.title = [NSString stringWithFormat:@"资产变更[%@]",[[UserDefaults userDefaults] getdata:kUserName]];
    
    [self.navigationItem setBackItemWithTarget:self action:@selector(replyButton)];
    
    [self.navigationItem setRightItemsWithTarget:self action1:@selector(submitButton) action2:@selector(allCheck:) title1:@"提交" title2:@"全选"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //获取数据
    [self getData];
}

-(void)getData
{
    [self.dataSource removeAllObjects];

    if (getMore) {
        [self connect];
        getMore = NO;
    }
    else if([[CommentData sharedInstance] getData:KAssetChangeName].count != 0){
        self.dataSource = [[CommentData sharedInstance] getData:KAssetChangeName];
    }
    else{
        [self connect];
    }
}

-(void)connect
{
    NSDictionary *para = @{@"keywd":@"" ,@"page":[NSString stringWithFormat:@"%d",page],@"size":@"5"};
    
    [[JiaoTongBuClient sharedClient] startGet:getAssetPageListCode parameters:para withCallBack:^(int flag, NSDictionary *dic, NSError *error) {
        if (flag == 0) {
            [self loadData:dic];
        }
        else if(flag == 1){
            [self.tableView reloadData];
            [HHUD showMsg:KNoMoreData viewController:self];
        }
        else{
            [HHUD showMsg:error.localizedDescription viewController:self];
        }
    }];
}

-(void)loadData:(NSDictionary *)dic
{
    NSArray *arr = dic[@"data"];
    for (int i = 0 ; i < [arr count]; i++) {
        [[CommentData sharedInstance] insertData:arr[i] entityName:KAssetChangeCode];
    }
    
    self.dataSource = [[CommentData sharedInstance] getData:KAssetChangeName];
    [self.tableView reloadData];
}



//返回上级界面
-(void)replyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)allCheck:(id)sender
{
    UIButton *cb = (UIButton *)sender;
    cb.tag = (cb.tag + 1) % 2;
    if (cb.tag) {
        for (int i = 0; i < self.dataSource.count; i++) {
            AssetChange * tmp = self.dataSource[i];
            [tmp setIsChecked:YES];
        }
    }
    else{
        for (int i = 0; i < self.dataSource.count; i++) {
            AssetChange * tmp = self.dataSource[i];
            [tmp setIsChecked:NO];
        }
    }
    [[CommentData sharedInstance] saveData];
    [self.tableView reloadData];
}
//获取选择退还的资产
-(NSString *)getAids
{
    NSString * aids = [[NSString alloc] init];
    aids = [NSString stringWithFormat:@""];
    for (int i = 0 ; i < self.dataSource.count; i++) {
        AssetChange * tmp = self.dataSource[i];
        if (tmp.isChecked) {
            aids = [NSString stringWithFormat:@"%@%@,",aids,tmp.assetID];
        }
    }
    NSLog(@"%@",aids);
    return aids;
}
//点击提交按钮
-(void)submitButton
{
    NSString * aids = [self getAids];
   
    if ([aids isEqualToString:@""]) {
        [HHUD showMsg:@"您还没有选择资产" viewController:self];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"申请退还！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
    }
}
//弹出确定提示框
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self submit];
            break;
        case 1:
            break;
        default:
            break;
    }
}
//网络提交
-(void)submit
{
    NSString * aids = [self getAids];
    NSDictionary *para = @{@"aids":aids};
    [[JiaoTongBuClient sharedClient] startGet:applyRefundCode parameters:para withCallBack:^(int flag, NSDictionary *dic, NSError *error) {
        if (flag != 2) {
            [HHUD showMsg:dic[@"msg"] viewController:self];
        }
        else{
            [HHUD showMsg:error.localizedDescription viewController:self];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AssetChangeCell";
    AssetChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    if(cell == nil)
    {
        cell = [[AssetChangeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //没有选中样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.dataSource.count) {
        
        if (!indexPath.row%2) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonAssetBG-0"]];
        }
        else{
               cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonAssetBG-1"]];
        }
        
        AssetChange *tmp = self.dataSource[indexPath.row];
        //自定义单选框
        if (tmp.isChecked) {
            cell.CheckButton.selected = 1;
        }
        else{
            cell.CheckButton.selected = 0;
        }
        //标记
        cell.CheckButton.tag = indexPath.row;
        
        
        [cell.CheckButton setBackgroundImage:[UIImage imageNamed:@"选择框"] forState:UIControlStateNormal];
        [cell.CheckButton setBackgroundImage:[UIImage imageNamed:@"选择框-1"] forState:UIControlStateSelected];
        
        [cell setData:tmp];

        [cell loadimg:tmp.assetImgPath];
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetChangeCell *cell = (AssetChangeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    AssetChange * tmp = self.dataSource[indexPath.row];
    UIButton * cb= (UIButton *)cell.CheckButton;
    cb.selected = !cb.selected;
    if (cb.selected == 1) {
        tmp.isChecked = 1;
    }
    else{
        tmp.isChecked = 0;
    }
    [[CommentData sharedInstance] saveData];
}

-(IBAction)selectButton:(id)sender
{
    UIButton *cb = (UIButton*)sender;
    AssetChange * tmp = self.dataSource[cb.tag];
    cb.selected = !cb.selected;
    if (cb.selected == 1) {
        tmp.isChecked = 1;
    }
    else{
        tmp.isChecked = 0;
    }
}

#pragma 下拉刷新
- (void)addHeader
{
    __unsafe_unretained AssetChangeViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 模拟延迟加载数据，因此0.2秒后才调用
        [vc performSelector:@selector(NextView:) withObject:refreshView afterDelay:0.2];
        
    };
    _header = header;
}

- (void)NextView:(MJRefreshBaseView *)refreshView
{
    [[CommentData sharedInstance] delete:KAssetChangeName entityName:KAssetChangeCode];
    
    page = 1;
    [self getData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma 上拉加载

- (void)addFooter
{
    __unsafe_unretained AssetChangeViewController *vc = self;
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
    [self getData];
    [refreshView endRefreshing];
}


@end
