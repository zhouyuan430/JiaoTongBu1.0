//
//  LogInViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-10.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBox.h"

@interface LogInViewController : UIViewController <UITextFieldDelegate,NSXMLParserDelegate>
{
    //提示框
    MessageBox *HHUD;
}

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *logInButton;
@property (strong, nonatomic) IBOutlet UIButton *isSaveButton;

-(IBAction)logInButton:(id)sender;
-(IBAction)saveButton:(id)sender;

@end
