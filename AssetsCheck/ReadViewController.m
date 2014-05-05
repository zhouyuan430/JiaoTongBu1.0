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
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, 320, 50)];
    text.textAlignment = NSTextAlignmentCenter;
    text.text = @"将二维码或条形码放在框内扫描";
    [self.view addSubview:text];
    
    [self read];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [ReaderView start];
}

-(void)read
{
    ReaderView = [[ZBarReaderView alloc]init];
    
    ReaderView.frame = CGRectMake(60, 120, 200, 200);
    ReaderView.readerDelegate = self;
    //关闭闪光灯
    ReaderView.torchMode = 0;
    //扫描区域
    CGRect   scanMaskRect = CGRectMake(0, 0, 200, 200);
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = ReaderView;
    }
    [self.view addSubview:ReaderView];
    //扫描区域计算
    ReaderView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:ReaderView.bounds];

}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    
    [self.delegate getReadSymbolStr:symbolStr fromImage:image];

    [readerView stop];
   
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
