//
//  ImageCache.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-23.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "ImageCache.h"


@implementation ImageCache

@dynamic key;
@dynamic data;


-(void)initWithData:(NSData *)_data key:(NSString *)_key
{
    self.key = _key;
    self.data = _data;
}
@end
