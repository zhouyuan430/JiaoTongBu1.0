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

//AFNetworking异步下载图片
-(void)loadimg:(NSString *)_url
{
    if(_url)
    {
        url = _url;
        //图片缓存查找
        NSString *cpic_spath=[[DiskCache sharedSearchCateLoad]cachePathForKey:_url];
        if([[NSFileManager defaultManager]fileExistsAtPath:cpic_spath])
        {
            imageData =[NSData dataWithContentsOfFile:cpic_spath];
            UIImage *aa=[UIImage imageWithData:imageData];
            [self setImage:aa];
            NSLog(@"本地");
        }
        else{
            //异步下载图片
            NSLog(@"下载");
            __weak AssetImage *weakCell = self;
            [self setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                     weakCell.image = image;
                                     //only required if no placeholder is set to force the imageview on the cell to be laid out to house the new image.
                                     //图片缓存
                                     NSData* data = UIImageJPEGRepresentation(weakCell.image, 1.0);
                                     weakCell.img = data;
                                     [[DiskCache sharedSearchCateLoad] storeData:data forKey:_url];
                                 }
                                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                     
                                 }];
            
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
