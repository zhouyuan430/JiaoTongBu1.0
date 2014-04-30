//
//  JiaoTongBuClient.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-20.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface JiaoTongBuClient : AFHTTPRequestOperationManager
{
    
}
+(instancetype)sharedClient;

-(NSDictionary *)XMLParser:(NSData *)data;

@end
