//
//  DirectCheckTableViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-25.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface DirectCheckTableViewController : UITableViewController <ZBarReaderDelegate>
{
    NSMutableArray *dataSource;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageview;

@end
