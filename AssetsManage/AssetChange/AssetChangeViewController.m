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
#import "AssetInfo.h"
#import "TMDiskCache.h"
@interface AssetChangeViewController ()

@end

static NSString* const KAssetsListPlist = @"AssetsList.plist";


@implementation AssetChangeViewController

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HHUD = [[MessageBox alloc] init];
    //添加下拉刷新
    [self addHeader];
    
    self.title = [NSString stringWithFormat:@"资产变更[%@]",[[UserDefaults userDefaults] getdata:kUserName]];
    //初始化数组
    dataSource = [[NSMutableArray alloc] initWithCapacity:20];
    isSelected = [[NSMutableArray alloc] initWithCapacity:20];
    //添加左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                   target:self
                                   action:@selector(replyButton)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UIBarButtonItem *allCheckButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(allCheck:)];
    allCheckButton.tag = 0;
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submitButton)];
    
    self.navigationItem.rightBarButtonItems = @[submitButton,allCheckButton];
    
    //获取数据
    [self getData];
}

-(void)getData
{
    [dataSource removeAllObjects];
    [self.tableView reloadData];

    if ([[TMDiskCache sharedCache] objectForKey:KAssetsListPlist] != nil) {
        NSLog(@"本地");
        [self loadData:(NSDictionary *)[[TMDiskCache sharedCache] objectForKey:KAssetsListPlist]];
        
    }
    else{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示

         NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
         NSString *token = [[UserDefaults userDefaults] getdata:kToken];
     
        NSDictionary *parameters = @{@"uid":uid,@"token":token};
        
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
            [HHUD showMsg:error.localizedDescription viewController:self];

        }];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //显示
    }
}

-(void)loadData:(NSDictionary *)dic
{
    NSArray *arr = dic[@"data"];
    for (int i = 0 ; i < [arr count]; i++) {
        AssetInfo *tmp = [[AssetInfo alloc] initWithData:arr[i]];
        
        [dataSource addObject:tmp];
        [isSelected addObject:@"0"];
    }
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
        for (int i = 0; i < [isSelected count]; i++) {
            isSelected[i] = @"1";
        }
    }
    else{
        for (int i = 0; i < [isSelected count]; i++) {
            isSelected[i] = @"0";
        }
    }
    [self.tableView reloadData];
}
//获取选择退还的资产
-(NSString *)getAids
{
    NSString * aids = [[NSString alloc] init];
    aids = [NSString stringWithFormat:@""];
    for (int i = 0 ; i < [isSelected count]; i++) {
        if ([isSelected[i] isEqualToString:@"1"]) {
            AssetInfo *tmp = dataSource[i];
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
        [HHUD showMsg:@"请选择资产" viewController:self];
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
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示
    
    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    
    NSDictionary *parameters = @{@"aids":aids,@"uid":uid,@"token":token};
    
    [[JiaoTongBuClient sharedClient] GET:applyRefund parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
        
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        if ([dic[@"status"] isEqualToString:@"A0006"]){
            [HHUD showMsg:dic[@"msg"] viewController:self];
        }
        else{
            [HHUD showMsg:dic[@"msg"] viewController:self];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [HHUD showMsg:error.localizedDescription viewController:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [dataSource count];
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
    if (indexPath.row < dataSource.count) {
        
        AssetInfo *tmp = dataSource[indexPath.row];
        //自定义单选框
        if ([isSelected[indexPath.row] isEqualToString:@"1"]) {
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
    UIButton * cb= (UIButton *)cell.CheckButton;
    cb.selected = !cb.selected;
    if (cb.selected == 1) {
        isSelected[cb.tag] = @"1";
    }
    else{
        isSelected[cb.tag] = @"0";
    }
}

-(IBAction)selectButton:(id)sender
{
    UIButton *cb = (UIButton*)sender;
    cb.selected = !cb.selected;
    if (cb.selected == 1) {
        isSelected[cb.tag] = @"1";
    }
    else{
        isSelected[cb.tag] = @"0";
    }
}

#pragma 下拉刷新
- (void)addHeader
{
    __unsafe_unretained AssetChangeViewController *vc = self;
    
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
    [self getData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}



@end
