//
//  DiskCache.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-14.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

static NSString  *datasuccess = @"Datasuccess";

@interface DiskCache : NSObject{
    NSDictionary *_getdictionary;
    NSMutableDictionary *memCache;
    NSString *diskCachePath;
    NSOperationQueue *cacheInQueue, *cacheOutQueue;
    NSString *totalurlcp;
    NSString *totalurlsc;
    NSString *totalurlys;
}

+ (DiskCache *)sharedSearchCateLoad;
- (void)cleanDisk:(NSInteger )intervalTime withfile:(NSString *)filePath;
//- ( void)loadByFirstKey:(NSString *)url bypost:(NSString *)post;//
- (void)storeKeyWithDataToDisk:(NSArray *)keyAndData;
- (NSString *)cachePathForKey:(NSString *)key;
- (NSData *)dataFromKey:(NSString *)key;
- (NSData *)dataFromKey:(NSString *)key fromDisk:(BOOL)fromDisk;//得到指定的data
- (NSString *) getFilePath:(NSString*)filename;
- (NSDictionary *) readFromFile:(NSString *) filePath;

- (void)storeData:(NSData *)aData forKey:(NSString *)key;
- (void)storeData:(NSData *)aData forKey:(NSString *)key toDisk:(BOOL)toDisk;//存储data

//添加
-(void)cleanDisk;
-(int )getSize;
@end
