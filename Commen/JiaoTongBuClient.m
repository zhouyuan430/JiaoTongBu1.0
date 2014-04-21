//
//  JiaoTongBuClient.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-20.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "JiaoTongBuClient.h"
static NSString * const JiaoTongBuBaseURLString = @"https://alpha-api.app.net/";

@implementation JiaoTongBuClient

+ (instancetype)sharedClient {
    static JiaoTongBuClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[JiaoTongBuClient alloc] initWithBaseURL:[NSURL URLWithString:JiaoTongBuBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    });
    
    return _sharedClient;
}

@end
