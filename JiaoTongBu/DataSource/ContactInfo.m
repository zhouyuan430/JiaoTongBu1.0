//
//  ContactInfo.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-22.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "ContactInfo.h"

@implementation ContactInfo

@dynamic contactName;
@dynamic contactEmail;
@dynamic contactImg;
@dynamic contactDepartment;

-(void)initWithData:(NSDictionary *)data
{    
    self.contactName = data[@"username"];
    self.contactEmail = data[@"email"];
    self.contactDepartment = data[@"rolelist"];
}


@end
