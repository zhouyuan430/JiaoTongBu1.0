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
#import "CommenData.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataSource = [[NSMutableArray alloc] initWithCapacity:20];
    isChecked = [[NSMutableArray alloc] initWithCapacity:20];
    
    [self getData];
    //添加左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                   target:self
                                   action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}
-(IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData
{
    if ([[CommenData mainShare] isExistsFile:KCheckListPlist]) {
        NSLog(@"本地");
        [self loadData:[[CommenData mainShare] getInfo:KCheckListPlist]];
    }
    else{
        NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
        NSString *token = [[UserDefaults userDefaults] getdata:kToken];
        
        NSString *url = [[NSString stringWithFormat:@"%@uid=%@&token=%@",getCheckList,uid,token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",url);
        
        [[JiaoTongBuClient sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
            
            NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
            if ([dic[@"status"] isEqualToString:@"A0006"])
            {
                //存储数据,历史缓存类型
                [[CommenData mainShare] saveInfo:dic fileName:KCheckListPlist];
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
    AssignmentCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    AssetInfo *tmp = dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([isChecked[indexPath.row] isEqualToString:@"1"]) {
        cell.isCheckButton.selected = 1;
    }
    else{
        cell.isCheckButton.selected = 0;
    }

    [cell.isCheckButton setBackgroundImage:[UIImage imageNamed:@"选择框"] forState:UIControlStateNormal];
    
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
    NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
    
    AssetInfo *tmp = dataSource[selectedRowIndex.row];
    
    AssignmentCheckCell *cell = (AssignmentCheckCell *)[self.tableView cellForRowAtIndexPath:selectedRowIndex];
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    //加上是否是正确的资产
    
    //此图片要上传
    [cell.isCheckButton setBackgroundImage:[info objectForKey: UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    
    UIImage * image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    else
    {
        data = UIImagePNGRepresentation(image);
    }
    [reader dismissViewControllerAnimated:YES completion:nil];

    [self upLoadImage:data  assetID:tmp.assetID];
    
   // [self upLoadCheckList:tmp.assetID path:@""];
}

-(void)upLoadImage:(NSData *)imageData assetID:(NSString *)aid
{
    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    
    NSString *url = [[NSString stringWithFormat:@"%@b=%@&token=%@&uid=%@",getAssetsList,uid,imageData,token] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[JiaoTongBuClient sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
        
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        [self upLoadCheckList:aid path:dic[@"data"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

-(void)upLoadCheckList:(NSString *)aid path:(NSString *)path
{
    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    
    NSString *url = [[NSString stringWithFormat:@"%@uid=%@&token=%@&path=%@&aid=%@",uploadCheckList,uid,token,path,aid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",url);
    
    [[JiaoTongBuClient sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
        
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        
        [self showMsg:dic[@"msg"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
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
