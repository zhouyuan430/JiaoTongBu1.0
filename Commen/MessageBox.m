//
//  MessageBox.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-14.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "MessageBox.h"
#import "AssetDetailViewController.h"

@implementation MessageBox

-(void)showMsg:(NSString*)msg viewController:(UIViewController *)view
{
    HUD = [[MBProgressHUD alloc] initWithView:view.view];
    [view.view addSubview:HUD];
    HUD.labelText = msg;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [self showHide:view];
    }];
}
-(void)showWait:(NSString*)msg viewController:(UIViewController *)view
{
    if ([view isKindOfClass:[UITableViewController class]]) {
        UITableViewController *vc = (UITableViewController*)view;
        vc.tableView.scrollEnabled = NO;
    }
    HUD = [[MBProgressHUD alloc] initWithView:view.view];
    [view.view addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.labelText = msg;
    [HUD show:YES];
}

//隐藏提示框
-(void)showHide:(UIViewController *)view
{
    if ([view isKindOfClass:[UITableViewController class]]) {
        UITableViewController *vc = (UITableViewController*)view;
        vc.tableView.scrollEnabled = YES;
    }
    [HUD removeFromSuperview];
}

@end
