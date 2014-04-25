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
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LogIn背景"]]];
    
    UIGraphicsBeginImageContext(CGSizeMake(5, 25));
    [[UIImage imageNamed:@"竖条" ] drawInRect:CGRectMake(0, 0, 5, 25)];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext() style:UIBarButtonItemStyleBordered target:self action:@selector(moreView:)];
    
    self.navigationItem.rightBarButtonItem = right;
    
    [BarItem setImage:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    
    
	// Do any additional setup after loading the view.
}

-(void)moreView:(id)sender
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
        case 0://设置
            
            [self performSegueWithIdentifier:@"SetUpViewController" sender:self];
            break;
            
        case 1:  //帮助
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
