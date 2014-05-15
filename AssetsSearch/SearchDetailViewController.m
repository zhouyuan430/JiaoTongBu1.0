//
//  SearchDetailViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-24.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "SearchDetailCell.h"
#import "AssetInfo.h"
#import "TMDiskCache.h"
#import "JiaoTongBuClient.h"
#import "DiskCache.h"

@interface SearchDetailViewController ()

@end

static NSString* const KAuthListPlist = @"AuthList.plist";
static CGFloat const KQuality = 0.0000001;

@implementation SearchDetailViewController

@synthesize dataSource;
@synthesize currentInfo;

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
    
    HHUD = [[MessageBox alloc] init];
    //一定要初始化
   // dataSource = [[NSMutableArray alloc] initWithCapacity:20];

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

- (void)addFooter
{
    __unsafe_unretained SearchDetailViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 增加5条假数据
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(PreviousView:) withObject:refreshView afterDelay:0.5];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}


- (void)addHeader
{
    __unsafe_unretained SearchDetailViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
        // 增加5条假数据
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(NextView:) withObject:refreshView afterDelay:0.5];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    
    //[header beginRefreshing];
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
    NSLog(@"yes");
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
        data = UIImageJPEGRepresentation(image, KQuality);
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{}];
        
        AssetInfo *tmp = dataSource[currentLine];
        
        [self upLoadImage:data info:tmp];

        [self.tableView reloadData];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma 上传图片

-(void)upLoadImage:(NSData *)imageData info:(AssetInfo*)tmp
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示
    
    [HHUD showWait:@"正在上传图片..." viewController:self];
    
    NSString *uid = [[UserDefaults userDefaults] getdata:kUserID];
    NSString *token = [[UserDefaults userDefaults] getdata:kToken];
    
    NSString *imageString = [imageData base64Encoding];
    
    
    NSDictionary *parameters =@{@"base64":imageString,@"uid":uid,@"token":token ,@"aid":tmp.assetID};
    [[JiaoTongBuClient sharedClient] POST:uploadAssetImages parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:responseObject];
        
        tmp.assetImgPath = [NSString stringWithFormat:@"%@",tmp.assetCardID];
        NSString *key = [NSString stringWithFormat:@"http://%@",tmp.assetImgPath];
        [[DiskCache sharedSearchCateLoad] storeData:imageData forKey:key];
        
        [HHUD showHide:self];
        [HHUD showMsg:dic[@"msg"] viewController:self];
        
        [self.tableView reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [HHUD showHide:self];
        [HHUD showMsg:error.localizedDescription viewController:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchDetailCell";
    SearchDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AssetInfo *tmp = dataSource[currentLine];
    
    [cell loadImgDetail:tmp.assetImgPath];
    
    [cell setData:tmp];
    
    return cell;
}

@end
