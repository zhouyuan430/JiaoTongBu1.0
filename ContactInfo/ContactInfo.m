//
//  ContactInfo.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-13.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "ContactInfo.h"

@implementation ContactInfo
@synthesize nameLabel;
@synthesize phoneLabel;
@synthesize emailLabel;
@synthesize addressLabel;
@synthesize departmentLabel;
@synthesize peopleImgUrl;
@synthesize peopleImg;

-(ContactInfo *)initWithData
{
    ContactInfo *tmp = [[ContactInfo alloc] init];
    
    
    return tmp;
}
@end
