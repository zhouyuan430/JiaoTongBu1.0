//
//  LogInViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-10.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "LogInViewController.h"
#import "AFNetworking.h"
#import "JiaoTongBuClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPSessionManager.h"
#import "GDataXMLNode.h"
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
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}
-(IBAction)logInButton:(id)sender
{
    //网络请求
    NSString *loginUrl = [NSString stringWithFormat:@"http://health.lekangba.cn/axis2/services/AssetManageInter/login?usrname=ajy&password=ajy"];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
    AFHTTPResponseSerializer * responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *ua = @"Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.1.1 Mobile/10A5376e Safari/8537.73.11";
    [requestSerializer setValue:ua forHTTPHeaderField:@"User-Agent"];
    
 //[requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-type"];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/xml",@"text/html" ,nil];
    manager.responseSerializer = responseSerializer;
    manager.requestSerializer = requestSerializer;
    
    [manager GET:loginUrl parameters:nil success:^(AFHTTPRequestOperation *operation, NSXMLParser *XMLParser) {
        NSData * data = (NSData*)XMLParser;
        NSLog(@"%@",[NSString stringWithUTF8String:[data bytes]]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
    //跳转
    [self toRootView];
}

-(NSString*)XMLParser:(NSData*)data
{
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    GDataXMLElement *rootElement = [doc rootElement];
    //节点
    GDataXMLElement *dicElement = [[rootElement elementsForName:@""] objectAtIndex:0];
    NSString *dic = [dicElement stringValue];
    NSLog(@"data is:%@",dic);
    return dic;
}

-(void)toRootView
{
    //跳转
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 获取故事板中某个View
    UIViewController *next = [board instantiateViewControllerWithIdentifier:@"rootViewController"];
    //跳转
    [self presentViewController:next animated:YES completion:^{}];
}

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
