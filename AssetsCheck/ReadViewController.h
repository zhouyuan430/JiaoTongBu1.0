//
//  ReadViewController.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-2.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

//实现委托回调功能
@protocol getReaderViewDelegate <NSObject>
@optional
-(void)getReadSymbolStr:(NSString *)symbolStr fromImage:(UIImage *)image;
@end

@interface ReadViewController : UIViewController<ZBarReaderDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}

@property (nonatomic, assign) id<getReaderViewDelegate> delegate;
@property (nonatomic, strong) UIImageView * line;


@end


