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

    dataSource = [[NSMutableArray alloc] initWithCapacity:20];
    isSelected = [[NSMutableArray alloc] initWithCapacity:20];
    //添加左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                   target:self
                                   action:@selector(replyButton)];
    [self.navigationItem setLeftBarButtonItem:leftButton];

    UIBarButtonItem *allCheckButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(allCheck)];
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submit)];
    
    self.navigationItem.rightBarButtonItems = @[submitButton,allCheckButton];
    
    [self getData];
    // Uncomment the following line to preserve selection between presentations.
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)getData
{
    if ([[CommenData mainShare] isExistsFile:AssetsListPlist]) {
        NSLog(@"本地");
        [self loadData:[[CommenData mainShare] getInfo:AssetsListPlist]];
        
    }
    else{
        /*
         NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
         NSString *token = [[UserDefaults userDefaults] getdata:kToken];
         
         NSString *url = [NSString stringWithFormat:@"%@uid=%@&token=%@",getContactList,uid,token];
         */
        NSString *url = [NSString stringWithFormat:@"%@",getAssetsList];
        
        [[JiaoTongBuClient sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
            
            NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
            if ([dic[@"status"] isEqualToString:@"A0006"])
            {
                //存储数据,历史缓存类型
                [[CommenData mainShare] saveInfo:dic fileName:AssetsListPlist];
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

-(void)allCheck
{
    
}

-(void)submit
{
    
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
    cell.CheckButton.tag = indexPath.row;
    [cell.CheckButton setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [cell.CheckButton setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateSelected];
    [cell.CheckButton addTarget:self action:@selector(touchUIInside:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.assetName.text = tmp.assetName;
    cell.assetcount.text = [NSString stringWithFormat:@"数量：%@",tmp.assetCount];
    cell.assetKind.text = [NSString stringWithFormat:@"种类：%@",tmp.assetCate];
    
    // Configure the cell...
    return cell;
}

-(IBAction)touchUIInside:(id)sender{
    UIButton * cb= (UIButton *)sender;
    cb.selected = !cb.selected;
    if (cb.selected == 1) {
        //isSelected[cb.tag] = @"0";
        [isSelected replaceObjectAtIndex:cb.tag withObject:@"1"];
    }
    else{
        [isSelected replaceObjectAtIndex:cb.tag withObject:@"0"];
    }
    NSLog(@"%@",isSelected[cb.tag]);

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
