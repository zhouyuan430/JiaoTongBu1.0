//
//  AssetImage.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-14.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetImage : UIImageView
{
    NSData *imageData;
    NSString *url;
}

@property (strong, nonatomic) NSData *img;

-(void)loadimg:(NSString*)_url;
@end
