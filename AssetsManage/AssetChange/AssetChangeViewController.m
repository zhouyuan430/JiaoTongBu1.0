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
#import "CommenData.h"
#import "AssetInfo.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"资产变更[%@]",[[UserDefaults userDefaults] getdata:kUserName]];
    
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
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submit)];
    
    self.navigationItem.rightBarButtonItems = @[submitButton,allCheckButton];
    
    [self getData];
    // Uncomment the following line to preserve selection between presentations.
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)getData
{
    if ([[CommenData mainShare] isExistsFile:KAssetsListPlist]) {
        NSLog(@"本地");
        [self loadData:[[CommenData mainShare] getInfo:KAssetsListPlist]];
        
    }
    else{
        
         NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
         NSString *token = [[UserDefaults userDefaults] getdata:kToken];
         
         NSString *url = [NSString stringWithFormat:@"%@uid=%@&token=%@",getAssetsList,uid,token];
     
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
        [isSelected addObject:@"0"];
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
            [isSelected replaceObjectAtIndex:i withObject:@"1"];
        }
    }
    else{
        for (int i = 0; i < [isSelected count]; i++) {
            [isSelected replaceObjectAtIndex:i withObject:@"0"];
        }
    }
    [self.tableView reloadData];
}

-(void)submit
{
    NSString * aids = [[NSString alloc] init];
    aids = [NSString stringWithFormat:@""];
    for (int i = 0 ; i < [isSelected count]; i++) {
        if ([isSelected[i] isEqualToString:@"1"]) {
            AssetInfo *tmp = dataSource[i];
            aids = [NSString stringWithFormat:@"%@%@,",aids,tmp.assetID];
        }
    }
    if ([aids isEqualToString:@""]) {
        [self showMsg:@"请选择资产"];
    }
    else{
        NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
        NSString *token = [[UserDefaults userDefaults] getdata:kToken];
        
        NSString *url = [NSString stringWithFormat:@"%@aids=%@&uid=%@&token=%@",applyRefund,aids,uid,token];

        [[JiaoTongBuClient sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
            
            NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
            if ([dic[@"status"] isEqualToString:@"A0006"]){
                [self showMsg:dic[@"msg"]];
            }
            else{
                [self showMsg:dic[@"msg"]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
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
    
    AssetInfo *tmp = dataSource[indexPath.row];
    //没有选中样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //自定义单选框
    if ([isSelected[indexPath.row] isEqualToString:@"1"]) {
        cell.CheckButton.selected = 1;
    }
    else{
        cell.CheckButton.selected = 0;
    }
    
    [cell.CheckButton setBackgroundImage:[UIImage imageNamed:@"选择框"] forState:UIControlStateNormal];
    [cell.CheckButton setBackgroundImage:[UIImage imageNamed:@"选择框-1"] forState:UIControlStateSelected];
    
    [cell setData:tmp];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetChangeCell *cell = (AssetChangeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    UIButton * cb= (UIButton *)cell.CheckButton;
    cb.selected = !cb.selected;
    if (cb.selected == 1) {
        [isSelected replaceObjectAtIndex:cb.tag withObject:@"1"];
    }
    else{
        [isSelected replaceObjectAtIndex:cb.tag withObject:@"0"];
    }
}

@end
