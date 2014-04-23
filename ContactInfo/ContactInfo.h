//
//  ContactInfo.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-13.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactInfo : NSObject
@property (strong, nonatomic) NSString *nameLabel;
@property (strong, nonatomic) NSString *phoneLabel;
@property (strong, nonatomic) NSString *emailLabel;
@property (strong, nonatomic) NSString *addressLabel;
@property (strong, nonatomic) NSString *departmentLabel;

@property (strong, nonatomic) NSString *peopleImgUrl;
@property (strong, nonatomic) UIImage *peopleImg;

-(ContactInfo *)initWithData:(NSDictionary *)data;
@end
