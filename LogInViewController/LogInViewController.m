//
//  LogInViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-10.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "LogInViewController.h"
#import "JiaoTongBuClient.h"
#import "AFHTTPRequestOperation.h"
#import "GDataXMLNode.h"
#import "ServerAddr.h"
@interface LogInViewController ()

@end
@implementation LogInViewController

@synthesize passwordTextField;
@synthesize userNameTextField;
@synthesize logInButton;
@synthesize isSaveButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//判断是否已经登录过，是否存在用户信息，如果有就直接跳转到首页
-(void)viewDidAppear:(BOOL)animated
{
    if ([[UserDefaults userDefaults] getdata:kUserName]) {
        [self logIn:[[UserDefaults userDefaults] getdata:kUserName] password:[[UserDefaults userDefaults] getdata:kPassword ]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [isSaveButton setBackgroundImage:[UIImage imageNamed:@"选择框"] forState:UIControlStateNormal];
    [isSaveButton setBackgroundImage:[UIImage imageNamed:@"选择框-1"] forState:UIControlStateSelected];
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    img1.image = [UIImage imageNamed:@"用户名"];
    userNameTextField.leftView = img1;
    userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    img2.image = [UIImage imageNamed:@"密码"];
    passwordTextField.leftView = img2;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    userNameTextField.disabledBackground = [UIImage imageNamed:@"框选中"];
    passwordTextField.disabledBackground = [UIImage imageNamed:@"框选中"];
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LogIn背景"]]];
	// Do any additional setup after loading the view.
}

-(IBAction)saveButton:(id)sender
{
    UIButton * cb= (UIButton *)sender;
    cb.selected = !cb.selected;
}
-(IBAction)logInButton:(id)sender
{
    [self logIn:userNameTextField.text password:passwordTextField.text];
}
//登录
-(void)logIn:(NSString *)userName password:(NSString *)password
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示
    //网络请求
    NSString *loginUrl = [[NSString stringWithFormat:@"%@usrname=%@&password=%@",login,userName,password] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[JiaoTongBuClient sharedClient] GET:loginUrl parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *XMLParser) {
        
        //XML解析
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:XMLParser];
        
        if ([dic[@"status"] isEqualToString:@"A0006"]) {
            
            NSArray *arr = dic[@"data"];
            NSDictionary *dict = [arr objectAtIndex:0];
            
            if (isSaveButton.selected) {
                //存储用户信息
                [[UserDefaults userDefaults] setdata:dict[@"token"] key:kToken];
                [[UserDefaults userDefaults] setdata:dict[@"name"] key:kUserName];
                [[UserDefaults userDefaults] setdata:dict[@"uid"] key:kUserID];
                [[UserDefaults userDefaults] setdata:password key:kPassword];
            }
            //跳转
            [self toRootView];
        }
        else{
            [self showMsg:dic[@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMsg:error.localizedDescription];
    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //显示
}

//弹出提示框
-(void)showMsg:(NSString*)msg
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

//跳转界面
-(void)toRootView
{
    //跳转
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 获取故事板中某个View
    UIViewController *next = [board instantiateViewControllerWithIdentifier:@"rootViewController"];
    //跳转
    [self presentViewController:next animated:YES completion:^{}];
}

#pragma mark -- 触摸其他地方隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [passwordTextField resignFirstResponder];
    [userNameTextField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
