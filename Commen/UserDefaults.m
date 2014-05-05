//
//  UserDefaults.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-22.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults
__strong static UserDefaults *singleton = nil;

+(instancetype)userDefaults
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[super allocWithZone:NULL] init];
    });
    return singleton;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [self userDefaults];
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void)setdata:(id)_data key:(NSString *)_key
{
    [[NSUserDefaults standardUserDefaults] setObject:_data forKey:_key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(id)getdata:(NSString *)_key
{
    if (_key) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:_key];
    }
    return nil;
}
-(void)removedata:(NSString *)_key
{
    if (_key) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:_key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
