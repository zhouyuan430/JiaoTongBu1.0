//
//  AssetsCheckViewController.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-10.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetsCheckViewController.h"
#import "DirectCheckTableViewController.h"
@interface AssetsCheckViewController ()

@end

@implementation AssetsCheckViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:1 alpha:1]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setBackItemWithTarget:self action:@selector(replyButton)];

    // Do any additional setup after loading the view.
}
-(void)replyButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)directCheck:(id)sender
{
    DirectCheckTableViewController *directVC = [[DirectCheckTableViewController alloc] init];
    
    [self.navigationController pushViewController:directVC animated:NO];
}



@end
