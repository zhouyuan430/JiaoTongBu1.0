//
//  DiskCache.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-14.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "DiskCache.h"

static DiskCache *instance;
static NSString* const kDataCacheDirectory=@"ImageCache";

@implementation DiskCache


-(id)init{
    if ((self = [super init])){
        
        memCache = [[NSMutableDictionary alloc] init];
		
        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kDataCacheDirectory];
		
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        // Init the operation queue
        cacheInQueue = [[NSOperationQueue alloc] init];
        cacheInQueue.maxConcurrentOperationCount = 1;
        cacheOutQueue = [[NSOperationQueue alloc] init];
        cacheOutQueue.maxConcurrentOperationCount = 1;
        
    }
    return self;
    
}

-(void)succeed:(NSDictionary *)dict{
    
    NSArray *tA=[dict objectForKey:@"data"];
    
    NSNotification * notification = [NSNotification notificationWithName:datasuccess object:tA];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //[tA retain];
    
}


#pragma mark SDDataCache (class methods)

+ (DiskCache *)sharedSearchCateLoad
{
    if (instance == nil)
    {
        instance = [[DiskCache alloc] init];
    }
	
    return instance;
}

//具体文件路径
- (NSString *)cachePathForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
	//diskcachepath:所有文件存储目录
    return [diskCachePath stringByAppendingPathComponent:filename];
}


#pragma mark DataCache

- (void)storeData:(NSData *)aData forKey:(NSString *)key
{
	[self storeData:aData forKey:key toDisk:YES];
}

- (void)storeData:(NSData *)aData forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    if (!aData || !key)
    {
        return;
    }
	
    if (toDisk && !aData)
    {
        return;
    }
	
    [memCache setObject:aData forKey:key];
	
    if (toDisk)
    {
		NSArray *keyWithData = [NSArray arrayWithObjects:key, nil];
		
        [cacheInQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(storeKeyWithDataToDisk:)
                                                                          object:keyWithData] ];
    }
}

- (void)storeKeyWithDataToDisk:(NSArray *)keyAndData
{
    // Can't use defaultManager another thread
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *key = [keyAndData objectAtIndex:0];
	// If no data representation given, convert the UIImage in JPEG and store it
	// This trick is more CPU/memory intensive and doesn't preserve alpha channel
	NSData *data=[self dataFromKey:key fromDisk:YES];  // be thread safe with no lock
	if (data)
	{
		[fileManager createFileAtPath:[self cachePathForKey:key] contents:data attributes:nil];
        
	}
    
}

//从硬盘读取数据
- (NSData *)dataFromKey:(NSString *)key
{
    return [self dataFromKey:key fromDisk:YES];
}

- (NSData *)dataFromKey:(NSString *)key fromDisk:(BOOL)fromDisk
{
    if (key == nil)
    {
        return nil;
    }
	
	NSData *data=[memCache objectForKey:key];
	
    if (!data && fromDisk)
    {
		data=[[NSData alloc] initWithContentsOfFile:[self cachePathForKey:key]] ;
        if (data)
        {
            [memCache setObject:data forKey:key];
        }
    }
	
    return data;
}


-(NSString *) getFilePath:(NSString*)filename
{
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //    NSString * cachepath = [paths stringByAppendingPathComponent:[appUserInfo sharedappUserInfo].token];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:paths])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:paths
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    return [paths stringByAppendingPathComponent:filename];
}


-(NSDictionary *) readFromFile:(NSString *) filePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        return dict;
        
    }else{
        return nil;
    }
    
}

-(void)succeed:(NSDictionary *)dict Code:(NSInteger)_Code
{
}

-(void)failed:(NSInteger)errorCode
{
}
//NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
// NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];

- (void)cleanDisk:(NSInteger)intervalTime withfile:(NSString *)filePath
{
    NSDate *currentDate=[NSDate date];
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    NSDate *modificationDate=[attrs fileModificationDate];
    NSDate *expirationDate = [modificationDate dateByAddingTimeInterval:intervalTime];
    if ([currentDate compare:expirationDate]==NSOrderedDescending)
    {   NSLog(@"yes al delete");
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

- (void)cleanDisk
{
    //NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-cacheMaxCacheAge];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        //NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
        //{
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        //}
    }
}
///Users/shuukougyoku/Library/Application Support/
-(int)getSize
{
    int size = 0;
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

-(void)dealloc
{
    //  [_dictionary release];
}




@end
