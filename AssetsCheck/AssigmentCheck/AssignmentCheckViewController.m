//
//  AssignmentCheckViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-10.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssignmentCheckViewController.h"
#import "AssignmentCheckCell.h"
#import "CheckAssetInfo.h"
#import "TMDiskCache.h"
#import "JiaoTongBuClient.h"
#import "ReadViewController.h"
#import "ZBarSDK.h"
#import "ParseQRCode.h"
#import "DiskCache.h"

@interface AssignmentCheckViewController ()

@end

static NSString* const KCheckListPlist = @"CheckList.plist";
static NSString* const KCheckFlag = @"CheckFlag.plist";
static NSString* const KCheckSource = @"CheckSource";


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
    
    HHUD = [[MessageBox alloc] init];
    //下拉刷新
    //[self addHeader];
    
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
    submitCount =  0;
    checkedCount = 0;
    unCheckedCount = 0;
}

-(void)initDataWithDataSource
{
    for (int i = 0; i < dataSource.count; i++) {
        CheckAssetInfo *tmp = dataSource[i];
        if ([tmp.checkFlag isEqualToString:@"2"]) {
            submitCount++;
        }
        else if([tmp.checkFlag isEqualToString:@"1"])
        {
            checkedCount++;
        }
        else
        {
            unCheckedCount++;
        }
    }
    NSLog(@"%d %d %d",submitCount,checkedCount,unCheckedCount);
}

-(IBAction)ReplyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData
{
    [dataSource removeAllObjects];
    
    [self.tableView reloadData];
    
    //restore data
    NSData *savedEncodedData = [[UserDefaults userDefaults] getdata:KCheckSource];
    if(savedEncodedData != nil)
    {
        dataSource = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedData];
        
        [self initDataWithDataSource];
        
        [self.tableView reloadData];
    }
    else{
        if ([[TMDiskCache sharedCache] objectForKey:KCheckListPlist] != nil) {
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
                    [HHUD showMsg:dic[@"msg"] viewController:self];
                }
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
                [HHUD showMsg:error.localizedDescription viewController:self];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
            }];
        }
    }
}

-(void)loadData:(NSDictionary *)dic
{
    NSArray *arr = dic[@"data"];
    for (int i = 0 ; i < [arr count]; i++) {
        CheckAssetInfo *tmp = [[CheckAssetInfo alloc] initWithCheckData:arr[i]];
        [dataSource addObject:tmp];
    }
    [self saveData];
    [self.tableView reloadData];
}

-(void)saveData
{
    NSData *encodedDataSource = [NSKeyedArchiver archivedDataWithRootObject:dataSource];
    [[UserDefaults userDefaults] setdata:encodedDataSource key:KCheckSource];
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
    [HHUD showHide:self];
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AssignmentCheckCell";
    AssignmentCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AssignmentCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.row < dataSource.count) {
        CheckAssetInfo *tmp = dataSource[indexPath.row];
        if ([tmp.checkFlag isEqualToString:@"2"]) {
            [cell.isCheckButton setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        }
        else if([tmp.checkFlag isEqualToString:@"1"]){
            [cell.isCheckButton setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        }
        else{
            [cell.isCheckButton setBackgroundImage:[UIImage imageNamed:@"选择框"] forState:UIControlStateNormal];
        }
        [cell loadimg:tmp.assetImgPath];
        [cell setData:tmp];
    }
    // Configure the cell...
    return cell;
}

#pragma ------ 二维码扫描
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckAssetInfo *tmp = dataSource[indexPath.row];
    if (![tmp.checkFlag isEqualToString:@"0"]) {
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
    
    ParseQRCode * parse = [[ParseQRCode alloc] initWithData:symbolStr];
    CheckAssetInfo *tmp = dataSource[selectedRowIndex.row];
    
    if (![parse.parseInfo[@"cardid"] isEqualToString:tmp.assetCardID]) {
        [HHUD showMsg:@"扫描资产不匹配" viewController:self];
        return;
    }
    
    tmp.assetImg = image;
    tmp.checkFlag = @"1";

    [dataSource insertObject:tmp atIndex:checkedCount + submitCount];
    [dataSource removeObjectAtIndex:selectedRowIndex.row+1];
    
    checkedCount++;
    
    [self saveData];
    [self.tableView reloadData];
    
    self.tableView.scrollsToTop = YES;
}

#pragma 上传图片

-(void)upLoadCheckLists:(NSData *)imageData info:(CheckAssetInfo*)tmp
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示
        
    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    
    NSString *imageString = [imageData base64Encoding];
    
    NSDictionary *parameters =@{@"uid":uid,@"token":token ,@"aid":tmp.assetID,@"qrBase64":imageString};
    
    [[JiaoTongBuClient sharedClient] POST:uploadCheckLists parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        
        tmp.assetImgPath = [NSString stringWithFormat:@"%@",tmp.assetCardID];
        NSString *key = [NSString stringWithFormat:@"http://%@",tmp.assetImgPath];
        [[DiskCache sharedSearchCateLoad] storeData:imageData forKey:key];
        
        [HHUD showHide:self];
        [HHUD showMsg:dic[@"msg"] viewController:self];
        
        //保存信息
        [self saveData];
        [self.tableView reloadData];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [HHUD showHide:self];
        [HHUD showMsg:error.localizedDescription viewController:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

-(void)submitButton
{
    if (checkedCount == 0) {
        [HHUD showMsg:@"请先盘点资产" viewController:self];
    }
    else{
        [HHUD showWait:@"正在上传..." viewController:self];
        for (int i = 0; i < dataSource.count; i++)
        {
            CheckAssetInfo *tmp = dataSource[i];
            if ([tmp.checkFlag isEqualToString:@"1"]) {
                tmp.checkFlag = @"2";
                CheckAssetInfo * tmp = dataSource[i];
                NSData *data = UIImageJPEGRepresentation(tmp.assetImg,0.000001);
                [self upLoadCheckLists:data info:tmp];
            }
        }
        int begin = submitCount;
        for (int i = begin; i <dataSource.count; i++) {
            CheckAssetInfo *tmp = dataSource[i];
            if ([tmp.checkFlag isEqualToString:@"2"]) {
                [dataSource insertObject:tmp atIndex:submitCount];
                [dataSource removeObjectAtIndex:i+1];
                submitCount ++;
            }
        }
    }
    checkedCount = 0;
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
