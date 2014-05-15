//
//  CustomSegue.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-9.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "CustomSegue.h"

@implementation CustomSegue

-(void)perform
{
    UIViewController *current = self.sourceViewController;
    UIViewController *next = self.destinationViewController;
    [current.navigationController pushViewController:next animated:NO];
}
@end
