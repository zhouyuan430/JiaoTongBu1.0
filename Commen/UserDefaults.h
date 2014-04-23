//
//  UserDefaults.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-22.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

+(instancetype)userDefaults;

-(void)setdata:(id)_data key:(NSString *)_key;

-(id)getdata:(NSString *)_key;

-(void)removedata:(NSString *)_key;

@end
