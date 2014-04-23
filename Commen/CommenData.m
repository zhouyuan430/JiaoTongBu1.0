//
//  CommenData.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-17.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "CommenData.h"

@implementation CommenData

static CommenData *_shareKit;

+ (CommenData *)mainShare
{
    if (nil == _shareKit) {
        _shareKit = [[CommenData alloc] init];
    }
    return _shareKit;
}

//读取数据
-(NSDictionary*)getInfo:(NSString *)fileName
{
    NSString *tempPath = NSTemporaryDirectory();
    NSString *path = [tempPath stringByAppendingPathComponent:fileName];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path] ;
    return dict;
}

//记录数据
-(void)saveInfo:(NSDictionary *)dict fileName:(NSString *)fileName
{
    
    NSString *tempPath = NSTemporaryDirectory();
    NSString *path = [tempPath stringByAppendingPathComponent:fileName];
    BOOL isSuccess = [dict writeToFile:path atomically:YES];
    if(!isSuccess)
    {
        NSLog(@"保存失败");
    }
}

//查找文件
-(Boolean)isExistsFile:(NSString *)fileName
{
    NSFileManager *filemanage = [NSFileManager defaultManager];
    //找出文件路径
    NSString *tempPath = NSTemporaryDirectory();
    NSString *path = [tempPath stringByAppendingPathComponent:fileName];
    return [filemanage fileExistsAtPath:path];
}

//创建目录
-(Boolean)createfolder:(NSString *)folderName
{
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *tempPath = NSTemporaryDirectory();
    NSString *path = [tempPath stringByAppendingPathComponent:folderName];

    path = [path stringByAppendingPathComponent:folderName];
    
    BOOL a = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    
    return a;
}
//删除文件
-(Boolean)DeleteFile:(NSString *)fileName
{
    NSString *tempPath = NSTemporaryDirectory();
    NSString *path = [tempPath stringByAppendingPathComponent:fileName];

    NSFileManager *defaultManager;
    defaultManager = [NSFileManager defaultManager];
    
    BOOL boolValue = [defaultManager removeItemAtPath:path error:nil];
    return boolValue;
}



@end
