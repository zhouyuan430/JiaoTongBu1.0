//
//  ReadViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-2.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "ReadViewController.h"
#import "ZBarSDK.h"

@interface ReadViewController ()

@end

@implementation ReadViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"盘点扫描";
    self.view.backgroundColor = [UIColor whiteColor];
    [self read];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)read
{
    num = 0;
    upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    
    
    //设置代理
    reader.readerDelegate = self;
    
    reader.showsZBarControls = NO;
    
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;

    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(20, 80, 280, 280);
    [view addSubview:image];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 280, 40)];
    label.text = @"将二维码或条形码放在框内扫描";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-64, 320, 64)];
    bar.backgroundColor = RGBA(70, 70, 70, 1);//[[UIColor alloc] initWithRed:70/255 green:70/255 blue:70/255 alpha:1];
    [reader.view insertSubview:bar atIndex:1];

    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 64)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    
    [cancel addTarget:self action:@selector(didCancel) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:cancel];

    [self presentViewController:reader animated:NO completion:^{
        
    }];
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}

-(void)didCancel
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:NO completion:^{
        [picker removeFromParentViewController];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    
    [picker dismissViewControllerAnimated:NO completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [self imageWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
        for (symbol in results){
            break;
        }
        NSString * result;
        result = symbol.data;
        
        [self.delegate getReadSymbolStr:result fromImage:image];

        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,200,200)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}




@end
