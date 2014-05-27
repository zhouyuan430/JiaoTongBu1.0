//
//  AssignmentCheckViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-10.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssignmentCheckViewController.h"
#import "AssignmentCheckCell.h"
#import "JiaoTongBuClient.h"
#import "ReadViewController.h"
#import "ZBarSDK.h"
#import "ParseQRCode.h"
#import "AssetImage.h"
#import "CommentData.h"
#import "AssetCheck.h"

@interface AssignmentCheckViewController ()

@end

static int page = 1;

@implementation AssignmentCheckViewController
@synthesize dataSource = _dataSource;

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
    [self.tableView removeObserver:_footer forKeyPath:@"contentOffset"];
    [self.tableView removeObserver:_footer forKeyPath:@"contentSize"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HHUD = [[MessageBox alloc] init];
    //下拉刷新
    //[self addHeader];
    [self addFooter];
    
    [self initData];
    
    [self.navigationItem setBackItemWithTarget:self action:@selector(replyButton)];
    
    [self.navigationItem setRightItemWithTarget:self action:@selector(submitButton) title:@"提交"];
    
    [self getData];
    
}

-(void)initData
{
    submitCount =  0;
    checkedCount = 0;
    unCheckedCount = 0;
}

-(void)initDataWithDataSource
{
    for (int i = 0; i < self.dataSource.count; i++) {
        AssetCheck *tmp = self.dataSource[i];
        if (tmp.checkFlag.intValue == 2) {
            submitCount++;
        }
        else if(tmp.checkFlag.intValue == 1){
            checkedCount++;
        }
        else{
            unCheckedCount++;
        }
    }
    NSLog(@"%d %d %d",submitCount,checkedCount,unCheckedCount);
}

-(void)replyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData
{
    [self.dataSource removeAllObjects];
    
    if(getMore)
    {
        [self connect];
        getMore = NO;
    }
    else{
        if ([[CommentData sharedInstance] getData:KAssetCheckName].count != 0) {
            self.dataSource = [[CommentData sharedInstance] getData:KAssetCheckName];
            [self initDataWithDataSource];
        }
        else{
            [self connect];
        }
    }
}

-(void)connect
{
    NSDictionary *para = @{@"page":[NSString stringWithFormat:@"%d",page],@"size":@"10"};
    [[JiaoTongBuClient sharedClient] startGet:getCheckPageListCode parameters:para withCallBack:^(int flag, NSDictionary *dic, NSError *error) {
        if (flag == 0) {
            [self loadData:dic];
        }
        else if(flag == 1){
            [HHUD showMsg:KNoMoreData viewController:self];
        }
        else{
            [HHUD showMsg:error.localizedDescription viewController:self];
        }
    }];
}

-(void)loadData:(NSDictionary *)dic
{
    NSArray *arr = dic[@"data"];
    for (int i = 0 ; i < [arr count]; i++) {
        [[CommentData sharedInstance] insertData:arr[i] entityName:KAssetCheckCode];
    }
   self.dataSource = [[CommentData sharedInstance] getData:KAssetCheckName];
    [self.tableView reloadData];
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
    return [self.dataSource count];
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
    
    if (indexPath.row < self.dataSource.count) {
        
        if (indexPath.row%2 == 0) {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonAssetBG-0"]];
        }
        else{
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PersonAssetBG-1"]];
        }
        AssetCheck *tmp = self.dataSource[indexPath.row];
        if (tmp.checkFlag.intValue == 2) {
            [cell.isCheckButton setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        }
        else if(tmp.checkFlag.intValue == 1){
            [cell.isCheckButton setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        }
        else{
            [cell.isCheckButton setBackgroundImage:[UIImage imageNamed:@"选择框"] forState:UIControlStateNormal];
        }
        
        [cell loadimg:tmp.assetImgPath];
        
        cell.assetName.text = tmp.assetName;
        cell.assetKind.text = [NSString stringWithFormat:@"类型：%@",tmp.assetCate];
        cell.assetCardID.text = [NSString stringWithFormat:@"固定资产编号：%@",tmp.assetCardID];
    }
    // Configure the cell...
    return cell;
}

#pragma ------ 二维码扫描
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetCheck *tmp = self.dataSource[indexPath.row];
    if (tmp.checkFlag.intValue == 2) {
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
    AssetCheck *tmp = self.dataSource[selectedRowIndex.row];
    
    if (![parse.parseInfo[@"cardid"] isEqualToString:tmp.assetCardID]) {
        [HHUD showMsg:@"扫描资产不匹配" viewController:self];
        return;
    }
    
    tmp.assetImgPath = tmp.assetCardID;
    NSData *data = UIImageJPEGRepresentation(image,1);
    [[CommentData sharedInstance] insertImgData:data key:tmp.assetImgPath];
    
    tmp.checkFlag = @1;
    [[CommentData sharedInstance] saveData];

    
    self.dataSource = [[CommentData sharedInstance] getData:KAssetCheckName];
    
    checkedCount++;
    
    [self.tableView reloadData];
    
    self.tableView.scrollsToTop = YES;
}

#pragma 上传图片

-(void)upLoadCheckLists:(NSData *)imageData info:(AssetCheck*)tmp
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

-(void)submitButton
{
    if (checkedCount == 0) {
        [HHUD showMsg:@"请先盘点资产" viewController:self];
    }
    else{
        [HHUD showWait:KUpLoading viewController:self];
        for (int i = 0; i < self.dataSource.count; i++)
        {
            AssetCheck *tmp = self.dataSource[i];
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
    [[CommentData sharedInstance] delete:KAssetCheckName entityName:KAssetCheckCode];
    page = 1;
    [self getData];
    
    //结束刷新状态
    [refreshView endRefreshing];
}

#pragma 上拉加载

- (void)addFooter
{
    __unsafe_unretained AssignmentCheckViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 模拟延迟加载数据，因此0.2秒后才调用）
        [vc performSelector:@selector(PreviousView:) withObject:refreshView afterDelay:0.2];
    };
    _footer = footer;
}
- (void)PreviousView:(MJRefreshBaseView *)refreshView
{
    getMore = YES;
    page ++;
    [self getData];
    [refreshView endRefreshing];
}


@end
