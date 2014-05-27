//
//  CommentData.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-22.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface CommentData : NSObject


@property (strong,nonatomic) AppDelegate *myDelegate;

+(CommentData *)sharedInstance;

//插入数据
-(void)insertData:(NSDictionary *)data  entityName:(NSInteger )entityNameCode;
//获取数据
-(NSMutableArray *)getData:(NSString *)entityName;
//删除数据
-(void)delete:(NSString *)entityName entityName:(NSInteger )entityNameCode;
//保存到数据库
-(void)saveData;


-(void)insertImgData:(NSData *)_data key:(NSString *)_key;
-(NSData *)cacheForKey:(NSString *)_key;


@end
