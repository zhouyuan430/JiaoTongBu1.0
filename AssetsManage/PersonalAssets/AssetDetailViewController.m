//
//  AssetDetailViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetDetailViewController.h"
#import "AssetDetailCell.h"
#import "AssetInfo.h"
#import "TMDiskCache.h"
#import "JiaoTongBuClient.h"
@interface AssetDetailViewController ()

@end

static NSString* const KAssetsListPlist = @"AssetsList.plist";

@implementation AssetDetailViewController

@synthesize assetInfo;
@synthesize currentInfo;
@synthesize dataSource;
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
    
    [self.tableView removeObserver:_footer forKeyPath:@"contentSize"];
    [self.tableView removeObserver:_footer forKeyPath:@"contentOffset"];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //一定要初始化
    //dataSource = [[NSMutableArray alloc] initWithCapacity:20];
    
    self.navigationController.navigationBarHidden = NO;
    currentLine = currentInfo.row;
    
    [self addFooter];
    [self addHeader];
    //添加左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                   target:self
                                   action:@selector(replyButton)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    [self.tableView reloadData];
}

-(void)replyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

//上拉加载
- (void)addFooter
{
    __unsafe_unretained AssetDetailViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 增加5条假数据
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(PreviousView:) withObject:refreshView afterDelay:0.2];
    };
    _footer = footer;
}

//下拉加载
- (void)addHeader
{
    __unsafe_unretained AssetDetailViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        // 模拟延迟加载数据，因此2秒后才调用）
        [vc performSelector:@selector(NextView:) withObject:refreshView afterDelay:0.2];
    };
    _header = header;
}

- (void)PreviousView:(MJRefreshBaseView *)refreshView
{
    if (currentLine>0) {
        currentLine--;
        [self.tableView reloadData];
    }
    [refreshView endRefreshing];
}
- (void)NextView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    if(currentLine < [dataSource count] - 1){
        currentLine++;
        [self.tableView reloadData];
    }
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}


#pragma -------------选取照片

-(IBAction)imgClick:(id)sender
{
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{}];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{}];
    
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{}];
        
        AssetInfo *tmp = [dataSource objectAtIndex:currentLine];
        tmp.assetImg = image;
        tmp.assetImgUrl = filePath;
        [self.tableView reloadData];
        
        [self upLoadImage:data assetID:tmp.assetID];
        //[self.assetImgButton setImage:image forState:UIControlStateNormal];
    }
    
}

-(void)upLoadImage:(NSData *)imageData assetID:(NSString *)aid
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示

    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    
    NSString *imageString = [imageData base64Encoding];
    
  
     NSDictionary *parameters =@{@"b":imageString,@"token":token ,@"uid":uid};
    [[JiaoTongBuClient sharedClient] POST:uploadImage parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        NSLog(@"%@",dic);
        [self upLoadAssetImage:aid path:[dic[@"data"] objectAtIndex:0][@"url"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:error.localizedDescription];
        NSLog(@"%@",error.localizedDescription);
    }];

}

-(void)upLoadAssetImage:(NSString *)aid path:(NSString *)path
{
    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    NSDictionary *parametes = @{@"uid":uid,@"token":token,@"path":path,@"aid":aid,@"cate":@"1"};
    
    [[JiaoTongBuClient sharedClient] GET:uploadAssetImage parameters:parametes success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        [self showMsg:dic[@"msg"]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //隐藏
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:error.localizedDescription];
        NSLog(@"%@",error.localizedDescription);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //隐藏
    }];
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


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)sendInfo
{
    NSLog(@"图片的路径是：%@", filePath);
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AssetDetailCell";
    AssetDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    assetInfo = [dataSource objectAtIndex:currentLine];
    
    if (assetInfo.assetImgUrl) {
        
    }
    
    [cell.assetImg setImage:assetInfo.assetImg forState:UIControlStateNormal];
    
    [cell setdata:assetInfo];
    // Configure the cell...
    
    return cell;
}


@end
