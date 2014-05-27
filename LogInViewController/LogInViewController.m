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
    if ( [[UserDefaults userDefaults] getdata:kPassword] ) {
        
        passwordTextField.text = [[UserDefaults userDefaults] getdata:kPassword];
        userNameTextField.text = [[UserDefaults userDefaults] getdata:kUserName];
        
        isSaveButton.selected = YES;
        
        [self logIn:userNameTextField.text password:passwordTextField.text];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    HHUD = [[MessageBox alloc] init];
    
    UIImageView *img12 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 21, 23)];
    img12.image = [UIImage imageNamed:@"UserName"];
    
    UIView *img11 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 23)];
    [img11 addSubview:img12];
    userNameTextField.leftView = img11;
    userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *img22 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 21, 23)];
    img22.image = [UIImage imageNamed:@"PassWord"];
    UIView *img21 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 23)];
    [img21 addSubview:img22];
    passwordTextField.leftView = img21;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        
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

-(void)logInfo
{
    if (![[UserDefaults userDefaults] getdata:kLogCount]) {
        NSNumber * t = @1;
        [[UserDefaults userDefaults] setdata:t key:kLogCount];
    }
    else{
        NSNumber * t = [[UserDefaults userDefaults] getdata:kLogCount];
        NSNumber * tt = [NSNumber numberWithInt:t.intValue + 1];
        [[UserDefaults userDefaults] setdata:tt key:kLogCount];
    }
    
    NSDate * date = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm:ss"];
    NSString * dateString=[dateformatter stringFromDate:date];
    
    //获得系统日期
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    
    NSString *nsDateString;
    if(month < 10){
        nsDateString= [NSString stringWithFormat:@"%d-0%d-%d %@",year,month,day,dateString];
    }
    else{
        nsDateString= [NSString stringWithFormat:@"%d-%d-%d %@",year,month,day,dateString];
    }
    [[UserDefaults userDefaults] setdata:nsDateString key:kLogDate];
}

//登录
-(void)logIn:(NSString *)userName password:(NSString *)password
{
    [self logInfo];
    [HHUD showWait:@"请稍等..." viewController:self];
    
    NSDictionary *para = @{@"userName":userName,@"password":password};
    [[JiaoTongBuClient sharedClient] startGet:loginCode parameters:para withCallBack:^(int flag, NSDictionary *dic,NSError *error) {
        [HHUD showHide:self];
        if (flag == 0) {
            if ([dic[@"status"] isEqualToString:@"A0006"]) {
                
                NSArray *arr = dic[@"data"];
                NSDictionary *dict = [arr objectAtIndex:0];
                
                //存储用户信息
                [[UserDefaults userDefaults] setdata:dict[@"token"] key:kToken];
                [[UserDefaults userDefaults] setdata:dict[@"name"] key:kUserName];
                [[UserDefaults userDefaults] setdata:dict[@"uid"] key:kUserID];
                
                if (isSaveButton.selected) {
                    [[UserDefaults userDefaults] setdata:password key:kPassword];
                }
                //跳转
               [self toRootView];
            }
        }
        else if(flag == 1){
            [HHUD showMsg:dic[@"msg"] viewController:self];
        }
        else{
            [HHUD showHide:self];
            [HHUD showMsg:error.localizedDescription viewController:self];
        }
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.background = [UIImage imageNamed:@"Input-1"];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.background = [UIImage imageNamed:@"Input"];
    return YES;
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
