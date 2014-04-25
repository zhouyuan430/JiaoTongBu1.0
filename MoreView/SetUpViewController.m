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
   

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    [[CommenData mainShare] DeleteFile:KAuthListPlist];
    [[CommenData mainShare] DeleteFile:KContactInfoPlist];
    [[CommenData mainShare] DeleteFile:KAssetsListPlist];
    
    [self performSegueWithIdentifier:@"LogInViewController" sender:self];
    
}
-(IBAction)clearCache:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
