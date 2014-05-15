//
//  MessageBox.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-14.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface MessageBox : NSObject
{
    MBProgressHUD *HUD;
}
-(void)showMsg:(NSString*)msg viewController:(UIViewController *)view;

-(void)showWait:(NSString*)msg viewController:(UIViewController *)view;

-(void)showHide:(UIViewController *)view;

@end
