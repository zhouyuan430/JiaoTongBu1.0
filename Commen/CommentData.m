//
//  CommentData.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-22.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "CommentData.h"
#import "ContactInfo.h"
#import "PersonAsset.h"
#import "AssetChange.h"
#import "ImageCache.h"
#import "AuthAsset.h"
#import "AssetCheck.h"
#import "AssetDirectCheck.h"

@implementation CommentData
@synthesize myDelegate = _myDelegate;


__strong static CommentData *commentData = nil;

+(CommentData*)sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred,^{
        commentData = [[super allocWithZone:NULL] init];
        commentData.myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    });
    return commentData;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void)insertImgData:(NSData *)_data key:(NSString *)_key
{
    ImageCache * tmp = (ImageCache *)[NSEntityDescription
                                        insertNewObjectForEntityForName:KImageCacheName
                                          inManagedObjectContext:self.myDelegate.managedObjectContext];
    [tmp initWithData:_data key:_key];
    [self saveData];
    
}
-(NSData *)cacheForKey:(NSString *)_key
{
    NSMutableArray *dataSouce = [self getData:KImageCacheName];
    int flag = -1;
    for (int i = 0; i < dataSouce.count; i++) {
        ImageCache * tmp = (ImageCache *)dataSouce[i];
        if ([tmp.key isEqualToString:_key]) {
            flag = i;
            break;
        }
    }
    if (flag != -1) {
        ImageCache * tmp = (ImageCache *)dataSouce[flag];
        return tmp.data;
    }
    else{
        return nil;
    }
}


-(void)saveData
{
    NSError *error;
    //托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    BOOL isSaveSuccess = [self.myDelegate.managedObjectContext save:&error];
    
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
}

-(NSMutableArray *)getData:(NSString *)entityName
{
    //创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.myDelegate.managedObjectContext];
    //设置请求实体
    [request setEntity:entity];
    
    if ([entityName isEqualToString:KAssetCheckName]) {
        NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"checkFlag" ascending:NO];
        NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"assetID" ascending:YES];
        NSArray *sort = [[NSArray alloc] initWithObjects:sort1,sort2,nil];
        [request setSortDescriptors:sort];
    }
    else if (![entityName isEqualToString:KImageCacheName] && ![entityName isEqualToString:KContactInfoName]) {
        NSSortDescriptor *sort1 =  [[NSSortDescriptor alloc] initWithKey:@"assetID" ascending:YES];
        NSArray *sort = [[NSArray alloc] initWithObjects:sort1, nil];
        [request setSortDescriptors:sort];
    }
    
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[self.myDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    return mutableFetchResult;
}


-(void)insertData:(NSDictionary *)data entityName:(NSInteger )entityNameCode
{

    if (entityNameCode == KContactInfoCode) {
        ContactInfo * tmp = (ContactInfo *)[NSEntityDescription
                                            insertNewObjectForEntityForName:KContactInfoName
                                            inManagedObjectContext:self.myDelegate.managedObjectContext];
        [tmp initWithData:data];
    }
    if (entityNameCode == KPersonAssetCode) {
        PersonAsset * tmp = (PersonAsset *)[NSEntityDescription
                                            insertNewObjectForEntityForName:KPersonAssetName
                                            inManagedObjectContext:self.myDelegate.managedObjectContext];
        [tmp initWithData:data];
    }
    if (entityNameCode == KAssetChangeCode) {
        AssetChange * tmp =(AssetChange *)[NSEntityDescription
                                           insertNewObjectForEntityForName:KAssetChangeName
                                           inManagedObjectContext:self.myDelegate.managedObjectContext];
        [tmp initWithData:data];
    }
    if (entityNameCode == KAuthAssetCode) {
        AuthAsset * tmp =(AuthAsset *)[NSEntityDescription
                                           insertNewObjectForEntityForName:KAuthAssetName
                                           inManagedObjectContext:self.myDelegate.managedObjectContext];
        [tmp initWithData:data];
    }
    if (entityNameCode == KAssetCheckCode) {
        AssetCheck * tmp =(AssetCheck *)[NSEntityDescription
                                       insertNewObjectForEntityForName:KAssetCheckName
                                       inManagedObjectContext:self.myDelegate.managedObjectContext];
        [tmp initCheckData:data];
    }
    if (entityNameCode == KAssetDirectCheckCode) {
        AssetDirectCheck * tmp =(AssetDirectCheck *)[NSEntityDescription
                                         insertNewObjectForEntityForName:KAssetDirectChechName
                                         inManagedObjectContext:self.myDelegate.managedObjectContext];
        [tmp initCheckData:data];
    }
    
    [self saveData];
}

-(void)delete:(NSString *)entityName entityName:(NSInteger )entityNameCode
{
    NSMutableArray *dataSouce = [self getData:entityName];
    for(int i = 0;i < dataSouce.count;i++)
    {
        [self.myDelegate.managedObjectContext deleteObject:dataSouce[i]];
    }
    [self saveData];
}







@end
