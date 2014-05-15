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
@interface DirectCheckTableViewController ()

@end

@implementation DirectCheckTableViewController

@synthesize imageview;

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
                                   action:@selector(replyButton)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                    target:self
                                    action:@selector(addButton)];
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(submitButton)];
    
    self.navigationItem.rightBarButtonItems = @[addButton,submitButton];
    
    [self scan];

	// Do any additional setup after loading the view.
}

-(void)addButton
{
    [self scan];
}

-(void)submitButton
{
    
}
-(void)scan
{
    ReadViewController *readerView = [[ReadViewController alloc] init];
    readerView.delegate = self;
    [self.navigationController pushViewController:readerView animated:NO];
}

-(void)getReadSymbolStr:(NSString *)symbolStr fromImage:(UIImage *)image
{
    AssetInfo * tmp = [[AssetInfo alloc] init];
    tmp.assetImg = image;
    tmp.assetName = symbolStr;
     [dataSource addObject:tmp];
    [self.tableView reloadData];
    
    //[self upLoadImage:data  assetID:tmp.assetID IndexPath:selectedRowIndex];
}
-(IBAction)replyButton
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
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DirectCheckCell";

    DirectCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.isCheckButton setBackgroundImage:dataSource[indexPath.row] forState:UIControlStateNormal];
    AssetInfo *tmp = dataSource[indexPath.row];
    
    cell.assetName.text = tmp.assetName;
    cell.img.image = tmp.assetImg;
    
    // Configure the cell...
    
    return cell;
}
@end
