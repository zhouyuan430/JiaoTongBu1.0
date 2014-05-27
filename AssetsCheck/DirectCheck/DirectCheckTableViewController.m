//
//  DirectCheckTableViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-25.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "DirectCheckTableViewController.h"
#import "ZBarSDK.h"
#import "DirectCheckCell.h"
#import "ReadViewController.h"
#import "ParseQRCode.h"
#import "CommentData.h"
#import "AssetDirectCheck.h"
#import "AssetImage.h"
#import "JiaoTongBuClient.h"

@interface DirectCheckTableViewController ()

@end

@implementation DirectCheckTableViewController

@synthesize dataSource = _dataSource;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:1 alpha:1]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    submitCount = 0;
    checkedCount = 0;
    
    [self.navigationItem setBackItemWithTarget:self action:@selector(replyButton)];
    [self.navigationItem setRightItemsWithTarget:self action1:@selector(addButton) action2:@selector(submitButton) title1:@"添加" title2:@"提交"];
    
    [self getData];
    
    [self scan];
	// Do any additional setup after loading the view.
}

-(void)initDataWithDataSource
{
    for (int i = 0; i < self.dataSource.count; i++) {
        AssetDirectCheck *tmp = self.dataSource[i];
        if (tmp.checkFlag.intValue == 2) {
            submitCount++;
        }
        else if(tmp.checkFlag.intValue == 1){
            checkedCount++;
        }
    }
    NSLog(@"%d %d",submitCount,checkedCount);
}

-(void)getData{
    self.dataSource = [[CommentData sharedInstance] getData:KAssetDirectChechName];
    [self initDataWithDataSource];
}

-(void)addButton{
    [self scan];
}

-(void)submitButton{
    if (checkedCount == 0) {
        [HHUD showMsg:@"请先盘点资产" viewController:self];
    }
    else{
        [HHUD showWait:KUpLoading viewController:self];
        for (int i = 0; i < self.dataSource.count; i++)
        {
            AssetDirectCheck *tmp = self.dataSource[i];
            if (tmp.checkFlag.intValue == 1){
                tmp.checkFlag = @2;
                
                AssetImage *img = [[AssetImage alloc] init];
                [img loadimg:tmp.assetImgPath];
                NSData *data = UIImageJPEGRepresentation(img.image,1);
                
                [self upLoadCheckLists:data info:tmp];
            }
        }
    }
    checkedCount = 0;
}

-(void)upLoadCheckLists:(NSData *)imageData info:(AssetDirectCheck *)tmp
{
    NSString *imageString = [imageData base64Encoding];
    NSDictionary *para =@{@"aid":tmp.assetID,@"qrBase64":imageString};
    [[JiaoTongBuClient sharedClient] startPost:uploadCheckListsCode parameters:para withCallBack:^(int flag, NSDictionary *dic, NSError *error) {
        if (flag != 2) {
            [[CommentData sharedInstance] saveData];
            [HHUD showHide:self];
            [HHUD showMsg:dic[@"msg"] viewController:self];
            [self.tableView reloadData];
        }
        else{
            [HHUD showHide:self];
            [HHUD showMsg:error.localizedDescription viewController:self];
        }
    }];
}


-(void)scan
{
    ReadViewController *readerView = [[ReadViewController alloc] init];
    readerView.delegate = self;
    [self.navigationController pushViewController:readerView animated:NO];
}

-(void)getReadSymbolStr:(NSString *)symbolStr fromImage:(UIImage *)image
{
    ParseQRCode * parse = [[ParseQRCode alloc] initWithData:symbolStr];
    [parse.parseInfo setObject:parse.parseInfo[@"cardid"] forKey:@"assetImgPath"];
    [[CommentData sharedInstance] insertData:parse.parseInfo entityName:KAssetDirectCheckCode];
    
    NSData *data = UIImageJPEGRepresentation(image,1);
    [[CommentData sharedInstance] insertImgData:data key:parse.parseInfo[@"cardid"]];
    
    self.dataSource = [[CommentData sharedInstance] getData:KAssetDirectChechName];
    [self.tableView reloadData];
}
-(void)replyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DirectCheckCell";

    DirectCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (indexPath.row < self.dataSource.count) {
        
        if (!indexPath.row%2) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonAssetBG-0"]];
        }
        else{
             cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonAssetBG-1"]];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        AssetDirectCheck * tmp = (AssetDirectCheck *)self.dataSource[indexPath.row];

        [cell loadimg:tmp.assetImgPath];
        
        cell.assetName.text = tmp.assetName;
        cell.assetKind.text = [NSString stringWithFormat:@"类型：%@",tmp.assetCate];
        cell.assetCardID.text = [NSString stringWithFormat:@"固定资产编号：%@",tmp.assetCardID];
    }
    // Configure the cell...
    
    return cell;
}
@end
