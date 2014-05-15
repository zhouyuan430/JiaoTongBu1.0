//
//  UpLoadImage.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-14.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageBox.h"
#import "AssetInfo.h"
@interface UpLoadImage : NSObject
{
    MessageBox *HHUD;
}

-(void)upLoadImage:(NSData *)imageData viewController:(UIViewController*)view info:(AssetInfo*)tmp;

@end
