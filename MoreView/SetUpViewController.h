//
//  SetUpViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-17.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetUpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *receiveButton;

-(IBAction)clearCache:(id)sender;
-(IBAction)changeUser:(id)sender;
@end
