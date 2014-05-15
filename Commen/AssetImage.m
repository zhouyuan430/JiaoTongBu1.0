//
//  AssetImage.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-14.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetImage.h"
#import "UIImageView+AFNetworking.h"
#import "DiskCache.h"
@implementation AssetImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


//自己的一部下载图片
-(void)loadimg:(NSString *)_url
{
    if (_url)
    {
        _url = [NSString stringWithFormat:@"http://%@",_url];        
        NSString *cpic_spath=[[DiskCache sharedSearchCateLoad] cachePathForKey:_url];
        if([[NSFileManager defaultManager]fileExistsAtPath:cpic_spath])
        {
            imageData =[NSData dataWithContentsOfFile:cpic_spath];
            UIImage *aa=[UIImage imageWithData:imageData];
            [self setImage:aa];
        }
        else{
            NSLog(@"下载");
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
                                       [[DiskCache sharedSearchCateLoad]storeData:DATA forKey:_url];
                                   });
                }
            });
        }
    }
}


@end
