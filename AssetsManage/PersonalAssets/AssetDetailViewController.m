//
//  AssetDetailViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetDetailViewController.h"
#import "AssetDetailCell.h"
#import "JiaoTongBuClient.h"
#import "Navbar.h"
#import "CommentData.h"

@interface AssetDetailViewController ()

@end

@implementation AssetDetailViewController

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
    
    HHUD = [[MessageBox alloc] init];
    //一定要初始化
    //dataSource = [[NSMutableArray alloc] initWithCapacity:20];
    
    self.navigationController.navigationBarHidden = NO;
    currentLine = currentInfo.row;
    
    [self addFooter];
    [self addHeader];
    
    [self.navigationItem setBackItemWithTarget:self action:@selector(replyButton)];
    
    [self.tableView reloadData];
}

-(void)replyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma ------下拉上拉刷新
//上拉加载
- (void)addFooter
{
    __unsafe_unretained AssetDetailViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 模拟延迟加载数据，因此0.2秒后才调用）
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
        // 模拟延迟加载数据，因此0.2秒后才调用）
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
    else{
        [HHUD showMsg:@"已经是第一个" viewController:self];
    }
    [refreshView endRefreshing];
}

- (void)NextView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    if(currentLine < dataSource.count - 1){
        currentLine++;
        [self.tableView reloadData];
    }
    else{
        [HHUD showMsg:@"已经是最后一个" viewController:self];
    }
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
        //NSLog(@"取消");
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
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{}];
    }
    else{
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{}];
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image CGSize:(CGSize)Size
{
    UIGraphicsBeginImageContext(Size);
    [image drawInRect:CGRectMake(0,0,Size.width,Size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [self imageWithImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] CGSize:CGSizeMake(200, 200)];
    
        NSData *data = UIImageJPEGRepresentation(image, 1);
        
        [picker dismissViewControllerAnimated:YES completion:^{}];
        
        //立即显示选中得图片
        PersonAsset *tmp = dataSource[currentLine];
        NSIndexPath *index = [NSIndexPath indexPathForRow:currentLine inSection:0];
        AssetDetailCell *cell = (AssetDetailCell*)[self.tableView cellForRowAtIndexPath:index];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,cell.assetImg.frame.size.width,cell.assetImg.frame.size.height)];
        img.image = image;
        [cell.assetImg addSubview:img];
        
        [self upLoadImage:data info:tmp];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma 上传图片

-(void)upLoadImage:(NSData *)imageData info:(PersonAsset *)tmp
{
    
    [HHUD showWait:KUpLoading viewController:self];
    NSString *imageString = [imageData base64Encoding];
    NSDictionary *para =@{@"base64":imageString,@"aid":tmp.assetID};
    
    [[JiaoTongBuClient sharedClient] startPost:uploadAssetImagesCode parameters:para withCallBack:^(int flag, NSDictionary *dic, NSError *error) {
        if (flag == 0) {
            tmp.assetImgPath = [NSString stringWithFormat:@"%@",tmp.assetCardID];
            [[CommentData sharedInstance] insertImgData:imageData key:tmp.assetImgPath];
            [HHUD showHide:self];
            [HHUD showMsg:dic[@"msg"] viewController:self];
        }
        else{
            [HHUD showHide:self];
            [HHUD showMsg:error.localizedDescription viewController:self];
        }
    }];}

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

    PersonAsset *tmp = dataSource[currentLine];
    
    [cell loadImgDetail:tmp.assetImgPath];
    
    [cell setdata:tmp];
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 700;
}

@end
