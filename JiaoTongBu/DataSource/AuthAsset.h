//
//  AuthAsset.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-23.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AuthAsset : NSManagedObject

@property (nonatomic, retain) NSNumber * assetID;
@property (nonatomic, retain) NSString * assetName;
@property (nonatomic, retain) NSString * assetCate;
@property (nonatomic, retain) NSString * assetValue;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * assetCount;
@property (nonatomic, retain) NSString * useDepartment;
@property (nonatomic, retain) NSString * assetCardID;
@property (nonatomic, retain) NSString * assetImgPath;
@property (nonatomic, retain) NSString * useOffice;
@property (nonatomic, retain) NSString * id_useOffice;
@property (nonatomic, retain) NSString * upLoadPath;


-(void)initWithData:(NSDictionary *)data;
@end
