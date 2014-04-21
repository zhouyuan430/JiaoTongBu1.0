//
//  CommenData.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-17.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.

//缓存临时文件  程序退出 数据删除 不能存自定义数据
//

#import <Foundation/Foundation.h>

@interface CommenData : NSObject

+ (CommenData *) mainShare;

//获取本地信息
-(NSDictionary*)getInfo:(NSString *)fileName;
//记录本地
-(void)saveInfo:(NSDictionary*)dict fileName:(NSString*)fileName;
//删除文件
-(Boolean)DeleteFile:(NSString*)fileName;
//检查文件是否存在
-(Boolean)isExistsFile:(NSString*)fileName;

@end
