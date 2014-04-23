//
//  UserDefaults.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-22.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults
static UserDefaults *_userDefaults;

+(instancetype)userDefaults
{
    if(nil == _userDefaults){
        _userDefaults = [[UserDefaults alloc] init];
    }
    return _userDefaults;
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
    }
}

@end
