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

@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * contactEmail;
@property (nonatomic, retain) NSString * contactImg;
@property (nonatomic, retain) NSString * contactDepartment;

@end
