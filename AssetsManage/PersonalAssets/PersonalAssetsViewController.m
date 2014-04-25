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
#import "AssetDetailViewController.h"
#import "CommenData.h"
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
/*
//隐藏搜索框
-(void)viewWillAppear:(BOOL)animated
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, 0);
    self.searchBar.hidden = YES;
}
//显示搜索框
-(void)searchButton
{
    self.navigationController.navigationBarHidden = YES;
    self.searchBar.hidden = NO;
    
    self.tableView.contentInset = UIEdgeInsetsMake(44+20, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44+20, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -(44+20));
}
*/
-(void)viewDidDisappear:(BOOL)animated
{
    if (searched) {
        NSLog(@"delete");
        [[CommenData mainShare] DeleteFile:KAssetsListPlist];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    searched = NO;
    dataSource = [[NSMutableArray alloc] initWithCapacity:20];
    
    self.title = [NSString stringWithFormat:@"资产[%@]",[[UserDefaults userDefaults] getdata:kUserName]];
    
    /*
    //添加左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(replyButton)];
    */
    //添加左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                   target:self
                                   action:@selector(replyButton)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
/*
    //添加右按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                    target:self
                                    action:@selector(searchButton)];
    [self.navigationItem setRightBarButtonItem:rightButton];
*/
    
    assetSearchBar.showsCancelButton = YES;
    [self getData:@""];
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//返回上级界面
-(void)replyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData:(NSString *)keywd
{
    [dataSource removeAllObjects];
    if ([[CommenData mainShare] isExistsFile:KAssetsListPlist]) {
        NSLog(@"本地");
        [self loadData:[[CommenData mainShare] getInfo:KAssetsListPlist]];
        
    }
    else{
        
        NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
        NSString *token = [[UserDefaults userDefaults] getdata:kToken];
        
        NSString *url = [[NSString stringWithFormat:@"%@uid=%@&keywd=%@&token=%@",getAssetsList,uid,keywd,token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[JiaoTongBuClient sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
            
            NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
            if ([dic[@"status"] isEqualToString:@"A0006"])
            {
                //存储数据,历史缓存类型
                [[CommenData mainShare] saveInfo:dic fileName:KAssetsListPlist];
                [self loadData:dic];
            }
            else{
                [self showMsg:dic[@"msg"]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
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
    static NSString *CellIdentifier = @"PersonalAssetCell";
    AssetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
          cell = [[AssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AssetInfo *tmp = [dataSource objectAtIndex:indexPath.row];
    
    cell.assetName.text = tmp.assetName;
    cell.assetKind.text = [NSString stringWithFormat:@"种类：%@",tmp.assetCate];
    cell.assetcount.text = [NSString stringWithFormat:@"数量：%@",tmp.assetCount];
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
    [[CommenData mainShare] DeleteFile:KAssetsListPlist];
    searched = YES;
    [self getData:searchBar.text];

    searchBar.text = @"";
    [self searchBarCancelButtonClicked:searchBar];
    [searchBar resignFirstResponder];
}

#pragma mark - Navigation
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [assetSearchBar resignFirstResponder];
    UIViewController *view = segue.destinationViewController;
    if ([view respondsToSelector:@selector(setAssetInfo:)])
    {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        //传递数据
        [view setValue:dataSource forKey:@"dataSource"];
        [view setValue:selectedRowIndex forKey:@"currentInfo"];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
