//
//  AssignmentCheckViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-10.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssignmentCheckViewController.h"
#import "AssignmentCheckCell.h"
#import "AssetInfo.h"
#import "TMDiskCache.h"
#import "JiaoTongBuClient.h"
#import "ReadViewController.h"
#import "ZBarSDK.h"
#import "ParseQRCode.h"

@interface AssignmentCheckViewController ()

@end

static NSString* const KCheckListPlist = @"CheckList.plist";
static NSString* const KCheckFlag = @"CheckFlag.plist";

@implementation AssignmentCheckViewController


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
    //[self.tableView removeObserver:_header forKeyPath:@"contentOffset"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //下拉刷新
   // [self addHeader];
    
    [self initData];
    
    //添加左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                   target:self
                                   action:@selector(ReplyButton)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self
                                    action:@selector(submitButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self getData];

}

-(void)initData
{
    dataSource = [[NSMutableArray alloc] initWithCapacity:20];
    isChecked = [[NSMutableArray alloc] initWithCapacity:20];
    submitCount =  0;
    checkedCount = 0;
    unCheckedCount = 0;
}


-(IBAction)ReplyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData
{
    [dataSource removeAllObjects];
    [isChecked removeAllObjects];
    //[assetsPath removeAllObjects];
    
    [self.tableView reloadData];

    if ([[TMDiskCache sharedCache] objectForKey:KCheckListPlist] != nil) {
        NSLog(@"本地");
        //isChecked = (NSMutableArray*)[[TMDiskCache sharedCache] objectForKey:KCheckFlag];
        
        
        [self loadData:(NSDictionary *)[[TMDiskCache sharedCache] objectForKey:KCheckListPlist]];
    }
    else{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示

        NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
        NSString *token = [[UserDefaults userDefaults] getdata:kToken];

        NSDictionary *parameters = @{@"uid":uid,@"token":token};

        [[JiaoTongBuClient sharedClient] GET:getCheckList parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
            
            NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
            if ([dic[@"status"] isEqualToString:@"A0006"])
            {
                //存储数据,历史缓存类型
                [[TMDiskCache sharedCache] setObject:dic forKey:KCheckListPlist];
                [self loadData:dic];
            }
            else{
                [self showMsg:dic[@"msg"]];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [self showMsg:error.localizedDescription];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        }];
    }
}

-(void)loadData:(NSDictionary *)dic
{
    NSArray *arr = dic[@"data"];
    for (int i = 0 ; i < [arr count]; i++) {
        AssetInfo *tmp = [[AssetInfo alloc] initWithCheckData:arr[i]];
        
        [dataSource addObject:tmp];
        
        [isChecked addObject:@"0"];
    }
    [self.tableView reloadData];
}

-(void)showMsg:(NSString *)msg
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = msg;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [self showHide];
    }];
}
-(void)showSubmit
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.labelText = @"正在上传...";
    [HUD show:YES];
}
//隐藏提示框
-(void)showHide
{
    [HUD removeFromSuperview];
    HUD = nil;
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
    static NSString *CellIdentifier = @"AssignmentCheckCell";
    AssignmentCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AssignmentCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    AssetInfo *tmp = dataSource[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([isChecked[indexPath.row] isEqualToString:@"2"]) {
        [cell.isCheckButton setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    else if([isChecked[indexPath.row] isEqualToString:@"1"]){
        [cell.isCheckButton setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
    else{
        [cell.isCheckButton setBackgroundImage:[UIImage imageNamed:@"选择框"] forState:UIControlStateNormal];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [cell setData:tmp];
    // Configure the cell...
    return cell;
}

#pragma ------ 二维码扫描
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![isChecked[indexPath.row] isEqualToString:@"0"]) {
        return;
    }
    ReadViewController *readerView = [[ReadViewController alloc] init];
    readerView.delegate = self;
    [self.navigationController pushViewController:readerView animated:NO];
}

-(void)getReadSymbolStr:(NSString *)symbolStr fromImage:(UIImage *)image
{
    //当前选中行
    NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
    AssignmentCheckCell *cell = (AssignmentCheckCell *)[self.tableView cellForRowAtIndexPath:selectedRowIndex];

    ParseQRCode * parse = [[ParseQRCode alloc] initWithData:symbolStr];
    AssetInfo *tmp = dataSource[selectedRowIndex.row];

    if (![parse.assetCardID isEqualToString:tmp.assetCardID]) {
        [self showMsg:@"扫描资产不匹配"];
        return;
    }
    
    
    
    cell.assetImg.image = image;
    tmp.assetImg = image;
    
    [dataSource insertObject:tmp atIndex:checkedCount];
    [dataSource removeObjectAtIndex:selectedRowIndex.row+1];
    //选中标记
    isChecked[checkedCount] = @"1";
    checkedCount++;
    
    [self.tableView reloadData];
    
    //NSData *data = UIImagePNGRepresentation(image);
    //[self upLoadImage:data  assetID:tmp.assetID IndexPath:selectedRowIndex];
}

#pragma ----- 数据上传
-(void)upLoadImage:(NSData *)imageData assetID:(NSString *)aid IndexPath:(NSIndexPath *)indexPath
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示

    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    
    NSDictionary *parameters = @{@"b":imageData,@"token":token,@"uid":uid};
    
    [[JiaoTongBuClient sharedClient] POST:uploadImage parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        NSLog(@"%@",dic);

        [self upLoadAssetImage:aid path:[dic[@"data"] objectAtIndex:0][@"url"] IndexPath:indexPath];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:error.localizedDescription];
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)upLoadAssetImage:(NSString *)aid path:(NSString *)path IndexPath:(NSIndexPath *)indexPath
{
    //设置path
    AssetInfo *tmp = dataSource[indexPath.row];
    tmp.upLoadPath = path;
    
    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    NSDictionary *parametes = @{@"uid":uid,@"token":token,@"path":path,@"aid":aid,@"cate":@"0"};
    
    [[JiaoTongBuClient sharedClient] GET:uploadAssetImage parameters:parametes success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        [self showMsg:dic[@"msg"]];
        [self upLoadCheckList:aid  path:path];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:error.localizedDescription];
        NSLog(@"%@",error.localizedDescription);
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //隐藏
}

-(void)submitButton
{
    int sum = 0;
    for (int i = 0; i < isChecked.count; i++) {
        if ([isChecked[i] isEqualToString:@"1"]) {
            
            //[self showSubmit];
            sum++;
            AssetInfo * tmp = dataSource[i];
            
            NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
            
            NSData *data = UIImagePNGRepresentation(tmp.assetImg);
            [self upLoadImage:data  assetID:tmp.assetID IndexPath:selectedRowIndex];
            [self.tableView reloadData];
        }
    }
   //[self showHide];
    if (sum == 0) {
        [self showMsg:@"请先盘点资产"];
    }
}

-(void)upLoadCheckList:(NSString *)aid path:(NSString *)path
{
    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];

    NSDictionary *parameters = @{@"uid":uid,@"token":token,@"path":path,@"aid":aid};
   
    [[JiaoTongBuClient sharedClient] GET:uploadCheckList parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
        
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        
        //[self showMsg:dic[@"msg"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma 下拉刷新
- (void)addHeader
{
    __unsafe_unretained AssignmentCheckViewController *vc = self;
    
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
    [[TMDiskCache sharedCache] removeObjectForKey:KCheckListPlist];
    [self getData];

    //结束刷新状态
    [refreshView endRefreshing];
}

@end
