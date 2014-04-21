//
//  JiaoTongBuClient.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-20.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface JiaoTongBuClient : AFHTTPSessionManager

+(instancetype)sharedClient;

@end
