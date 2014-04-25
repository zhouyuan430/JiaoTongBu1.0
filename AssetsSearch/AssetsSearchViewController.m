//
//  AssetsSearchViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-23.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetsSearchViewController.h"
#import "AssetInfo.h"
#import "CommenData.h"
#import "JiaoTongBuClient.h"
#import "AssetCell.h"
#import "SearchDetailViewController.h"
@interface AssetsSearchViewController ()

@end

static NSString* const KAuthListPlist = @"AuthList.plist";

@implementation AssetsSearchViewController

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
    dataSource = [[NSMutableArray alloc] initWithCapacity:20];
    
    //添加左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                   target:self
                                   action:@selector(ReplyButton)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示

    if ([[CommenData mainShare] isExistsFile:KAuthListPlist]) {
        NSLog(@"本地");
        [self loadData:[[CommenData mainShare] getInfo:KAuthListPlist]];
    }
    else{
        /*
        NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
        NSString *token = [[UserDefaults userDefaults] getdata:kToken];
        NSString *url = [NSString stringWithFormat:@"%@uid=%@&token=%@",getContactList,uid,token];
        */
        
        NSString *url = [[NSString stringWithFormat:@"%@",getAuthList] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[JiaoTongBuClient sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
            
            NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
            if ([dic[@"status"] isEqualToString:@"A0006"])
            {
                //存储数据,历史缓存类型
                [[CommenData mainShare] saveInfo:dic fileName:KAuthListPlist];
                [self loadData:dic];
            }
            else{
                [self showMsg:dic[@"msg"]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

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
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.searchBar resignFirstResponder];
    UIViewController *view = segue.destinationViewController;
    if ([view respondsToSelector:@selector(setAssetInfo:)])
    {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        [view setValue:selectedRowIndex forKey:@"currentInfo"];
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
