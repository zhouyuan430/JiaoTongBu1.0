//
//  DirectCheckTableViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-25.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadViewController.h"
#import "MessageBox.h"

@interface DirectCheckTableViewController : UITableViewController <getReaderViewDelegate>
{
    MessageBox *HHUD;
   int submitCount;
   int checkedCount;
}

@property (strong,nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) IBOutlet UIImageView *imageview;

@end
