//
//  SetUpViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-17.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "SetUpViewController.h"
#import "CommenData.h"
#import "DiskCache.h"

@interface SetUpViewController ()

@end

static NSString* const KAssetsListPlist = @"AssetsList.plist";
static NSString* const KContactInfoPlist = @"ContactInfo.plist";
static NSString* const KAuthListPlist = @"AuthList.plist";
static NSString* const KCheckListPlist = @"CheckList.plist";

@implementation SetUpViewController

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
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LogIn背景"]]];

    //添加左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                   target:self
                                   action:@selector(ReplyButton)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
   
}
-(void)ReplyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)changeUser:(id)sender
{
    [[UserDefaults userDefaults] removedata:kUserID];
    [[UserDefaults userDefaults] removedata:kUserName];
    [[UserDefaults userDefaults] removedata:kToken];
    [[UserDefaults userDefaults] removedata:kPassword];
    
    [self clear];
    
    [self performSegueWithIdentifier:@"LogInViewController" sender:self];
    
}
-(IBAction)clearCache:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清除缓存！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}

//弹出确定提示框
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self clear];
            [self showMsg:@"缓存清除完毕！"];
            break;
        case 1:
            break;
        default:
            break;
    }
}

-(void)clear
{
    [[CommenData mainShare] DeleteFile:KAuthListPlist];
    [[CommenData mainShare] DeleteFile:KContactInfoPlist];
    [[CommenData mainShare] DeleteFile:KAssetsListPlist];
    [[CommenData mainShare] DeleteFile:KCheckListPlist];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
