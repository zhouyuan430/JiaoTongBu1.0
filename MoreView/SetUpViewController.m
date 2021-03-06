//
//  SetUpViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-17.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "SetUpViewController.h"
#import "CommentData.h"

@interface SetUpViewController ()

@end

static NSString* const KAssetsListPlist = @"AssetsList.plist";
static NSString* const KContactInfoPlist = @"ContactInfo.plist";
static NSString* const KAuthListPlist = @"AuthList.plist";
static NSString* const KCheckListPlist = @"CheckList.plist";
static NSString* const KCheckSource = @"CheckSource";

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
    self.navigationController.navigationBar.translucent = YES;
    
    [self.navigationItem setBackItemWithTarget:self action:@selector(replyButton)];

}
-(void)replyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)changeUser:(id)sender
{
    [[UserDefaults userDefaults] removedata:kUserID];
    [[UserDefaults userDefaults] removedata:kUserName];
    [[UserDefaults userDefaults] removedata:kToken];
    [[UserDefaults userDefaults] removedata:kPassword];
    [[UserDefaults userDefaults] removedata:KCheckSource];

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
            [HHUD showMsg:@"缓存清除完毕" viewController:self];
            break;
        case 1:
            break;
        default:
            break;
    }
}

-(void)clear
{
    [[CommentData sharedInstance] delete:KImageCacheName entityName:KImageCacheCode];
    [[CommentData sharedInstance] delete:KPersonAssetName entityName:KPersonAssetCode];
    [[CommentData sharedInstance] delete:KContactInfoName entityName:KContactInfoCode];
    [[CommentData sharedInstance] delete:KAuthAssetName entityName:KAuthAssetCode];
    [[CommentData sharedInstance] delete:KAssetChangeName entityName:KAssetChangeCode];
    [[CommentData sharedInstance] delete:KAssetDirectChechName entityName:KAssetDirectCheckCode];
    
    [[UserDefaults userDefaults] removedata:KCheckSource];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
