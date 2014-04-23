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
    NSLog(@"%@",[[UserDefaults userDefaults] getdata:kUserName]);
    if ([[UserDefaults userDefaults] getdata:kUserName]) {
        [self toRootView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     
	// Do any additional setup after loading the view.
}
-(IBAction)logInButton:(id)sender
{
    //网络请求
    NSString *loginUrl = [NSString stringWithFormat:@"%@usrname=ajy&password=ajy",login];
        
    [[JiaoTongBuClient sharedClient] GET:loginUrl parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *XMLParser) {
        
        //XML解析
        NSDictionary *dic = [[JiaoTongBuClient sharedClient] XMLParser:XMLParser];
        
        if ([dic[@"status"] isEqualToString:@"A0006"]) {
            
            NSArray *arr = dic[@"data"];
            NSDictionary *dict = [arr objectAtIndex:0];
                                
            //存储用户信息
            [[UserDefaults userDefaults] setdata:dict[@"token"] key:kToken];
            [[UserDefaults userDefaults] setdata:dict[@"name"] key:kUserName];
            [[UserDefaults userDefaults] setdata:dict[@"uid"] key:kUserID];
            
            //跳转
            [self toRootView];
        }
        else{
            [self showMsg:dic[@"msg"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
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
