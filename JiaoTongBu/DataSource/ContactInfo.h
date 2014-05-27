//
//  ContactInfo.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-22.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ContactInfo : NSManagedObject

@property (nonatomic, strong) NSString * contactName;
@property (nonatomic, strong) NSString * contactEmail;
@property (nonatomic, strong) NSString * contactImg;
@property (nonatomic, strong) NSString * contactDepartment;


-(void)initWithData:(NSDictionary *)data;

@end
