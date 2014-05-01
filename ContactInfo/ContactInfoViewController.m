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
#import "TMDiskCache.h"

@interface ContactInfoViewController ()

@end

static NSString* const KContactInfoPlist = @"ContactInfo.plist";


@implementation ContactInfoViewController

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
    //添加左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                   target:self
                                   action:@selector(replyButton)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
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
    [dataSource removeAllObjects];
    [self.tableView reloadData];
    
    if ([[TMDiskCache sharedCache] objectForKey:KContactInfoPlist] != nil) {
        NSLog(@"本地");
       [self loadData:(NSDictionary *)[[TMDiskCache sharedCache] objectForKey:KContactInfoPlist]];
    }
    else{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示
        
        NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
        NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    
        NSDictionary *parameters = @{@"uid":uid,@"token":token};
        
        [[JiaoTongBuClient sharedClient] GET:getContactList parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
        
            NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
            if ([dic[@"status"] isEqualToString:@"A0006"])
            {
                [[TMDiskCache sharedCache] setObject:dic forKey:KContactInfoPlist];
                
                [self loadData:dic];
            }
            else{
                [self showMsg:dic[@"msg"]];
            }
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    }
}

-(void)loadData:(NSDictionary*)dic
{
    NSArray *arr = dic[@"data"];
    for (int i = 0 ; i < [arr count]; i++) {
        ContactInfo *tmp = [[ContactInfo alloc] initWithData:arr[i]];
        
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
    static NSString *CellIdentifier = @"ContactInfoCell";
    ContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[ContactInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    ContactInfo *tmp = dataSource[indexPath.row];
    [cell setCellInfo:tmp];
    
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
    [[TMDiskCache sharedCache] removeObjectForKey:KContactInfoPlist];
    [self getData];
    
    
    //结束刷新状态
    [refreshView endRefreshing];
}

@end
