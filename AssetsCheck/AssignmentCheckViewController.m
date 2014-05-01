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
#import "ZBarSDK.h"
@interface AssignmentCheckViewController ()

@end

static NSString* const KCheckListPlist = @"CheckList.plist";

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
    [self.tableView removeObserver:_header forKeyPath:@"contentOffset"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addHeader];
    
    dataSource = [[NSMutableArray alloc] initWithCapacity:20];
    isChecked = [[NSMutableArray alloc] initWithCapacity:20];
    assetsPath = [[NSMutableArray alloc] initWithCapacity:20];
    
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
-(IBAction)ReplyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData
{
    [dataSource removeAllObjects];
    [isChecked removeAllObjects];
    [assetsPath removeAllObjects];
    
    [self.tableView reloadData];

    if ([[TMDiskCache sharedCache] objectForKey:KCheckListPlist] != nil) {
        NSLog(@"本地");
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
        [assetsPath addObject:@"0"];
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
    static NSString *CellIdentifier = @"AssignmentCheckCell";
    AssignmentCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AssignmentCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    AssetInfo *tmp = dataSource[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([isChecked[indexPath.row] isEqualToString:@"1"]) {
        cell.isCheckButton.selected = 1;
    }
    else{
        cell.isCheckButton.selected = 0;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [cell.isCheckButton setBackgroundImage:[UIImage imageNamed:@"选择框"] forState:UIControlStateNormal];
    [cell.isCheckButton setBackgroundImage:[UIImage imageNamed:@"选择框-1"] forState:UIControlStateSelected];
    
    [cell setData:tmp];
    // Configure the cell...
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //扫描
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];

    [self presentViewController:reader animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //当前选中行
    NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
    
    //长传标记
    isChecked[selectedRowIndex.row] = @"1";
    
    
    AssetInfo *tmp = dataSource[selectedRowIndex.row];

    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    //加上是否是正确的资产
    
    UIImage * image = [info objectForKey: UIImagePickerControllerOriginalImage];
    NSData *data = UIImagePNGRepresentation(image);

    [reader dismissViewControllerAnimated:YES completion:nil];
    [self upLoadImage:data  assetID:tmp.assetID IndexPath:selectedRowIndex];
}

-(void)upLoadImage:(NSData *)imageData assetID:(NSString *)aid IndexPath:(NSIndexPath *)indexPath
{
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
    assetsPath[indexPath.row] = [NSString stringWithFormat:@"%@",path];
    
    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    NSDictionary *parametes = @{@"uid":uid,@"token":token,@"path":path,@"aid":aid,@"cate":@"0"};
    
    [[JiaoTongBuClient sharedClient] GET:uploadAssetImage parameters:parametes success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        [self showMsg:dic[@"msg"]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //隐藏
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:error.localizedDescription];
        NSLog(@"%@",error.localizedDescription);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //隐藏
    }];
}


-(void)submitButton
{
    for (int i = 0; i < isChecked.count; i++) {
        if ([isChecked[i] isEqualToString:@"1"]) {
            AssetInfo * tmp = dataSource[i];
            
            NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];

            AssignmentCheckCell *cell = (AssignmentCheckCell *)[self.tableView cellForRowAtIndexPath:selectedRowIndex];
            
            cell.isCheckButton.selected = YES;
            NSLog(@"%@",assetsPath[i]);
            [self upLoadCheckList:tmp.assetID  path:assetsPath[i]];
            
        }
    }
}


-(void)upLoadCheckList:(NSString *)aid path:(NSString *)path
{
    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];

    NSDictionary *parameters = @{@"uid":uid,@"token":token,@"path":path,@"aid":aid};
    
    [[JiaoTongBuClient sharedClient] GET:uploadCheckList parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
        
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        
        [self showMsg:dic[@"msg"]];
        [self.tableView reloadData];
        
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
