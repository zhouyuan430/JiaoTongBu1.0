//
//  RootViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-10.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "RootViewController.h"
#import "SetUpViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController
@synthesize personalAssets;
@synthesize AssetsChange;
@synthesize AssetsCheck;
@synthesize AssetsSearch;
@synthesize ContactInfo;
@synthesize BarItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        personalAssets.titleLabel.lineBreakMode = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
}

-(IBAction)moreView:(id)sender
{
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles: @"设置", @"帮助",nil];
    
    [myActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            
            [self performSegueWithIdentifier:@"SetUpViewController" sender:self];
            break;
            
        case 1:  //打开本地相册
            [self performSegueWithIdentifier:@"HelpViewController" sender:self];
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
