//
//  AssetImage.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-14.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetImage.h"
#import "CommentData.h"
@implementation AssetImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


//异步下载图片
-(void)loadimg:(NSString *)_url
{
    if (_url)
    {
        imageData = [[CommentData sharedInstance] cacheForKey:_url];
        if(imageData)
        {
            UIImage *aa=[UIImage imageWithData:imageData];
            [self setImage:aa];
        }
        else{
           // NSLog(@"下载");
            __block NSData *DATA = imageData;
            dispatch_queue_t  Queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(Queue, ^{
                NSURL * URL=[NSURL URLWithString:_url];
                DATA =[[NSData alloc]initWithContentsOfURL:URL];
                UIImage * image=[[UIImage alloc]initWithData:DATA];
                if (DATA!=nil)
                {
                    //通知主线程更新界面
                    dispatch_async(dispatch_get_main_queue(),
                                   ^{
                                       self.image = image;
                                       [[CommentData sharedInstance] insertImgData:DATA key:_url];
                                   });
                }
            });
        }
    }
}


@end
