//
//  ImageCache.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-23.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ImageCache : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSData * data;

@end
