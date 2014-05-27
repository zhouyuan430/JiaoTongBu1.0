//
//  RootViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-10.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "RootViewController.h"
#import "SetUpViewController.h"
#import "Navbar.h"
@interface RootViewController ()

@end

extern  NSString *gNavbarBackgroundImageName;

@implementation RootViewController
@synthesize personalAssets;
@synthesize AssetsChange;
@synthesize AssetsCheck;
@synthesize AssetsSearch;
@synthesize ContactInfo;
@synthesize BarItem;
@synthesize LogCount;
@synthesize logDate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        personalAssets.titleLabel.lineBreakMode = 0;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    gNavbarBackgroundImageName = @"MainNavigetionBar.png";
    [self.navigationController.navigationBar setNeedsDisplay];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:28.0/255.0 green:115.0/255.0 blue:174.0/255.0 alpha:1]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    gNavbarBackgroundImageName = @"NavigationBar.png";
    [self.navigationController.navigationBar setNeedsDisplay];
}

 
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setRightItemWithTarget:self action:@selector(moreView) image:@"MoreButton.png"];
    
    LogCount.text = [NSString stringWithFormat:@"尊敬的管理员用户您好，您已经登录%@次",    [[UserDefaults userDefaults] getdata:kLogCount]];
    
    logDate.text = [NSString stringWithFormat:@"上次登录时间是:%@",[[UserDefaults userDefaults] getdata:kLogDate]];
    
	// Do any additional setup after loading the view.
}

-(void)moreView
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
