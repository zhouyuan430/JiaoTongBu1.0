//
//  AssetChange.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-22.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AssetChange : NSManagedObject

@property (nonatomic, retain) NSString * assetCardID;
@property (nonatomic, retain) NSString * assetCate;
@property (nonatomic, retain) NSString * assetImgPath;
@property (nonatomic, retain) NSString * assetName;
@property (nonatomic, retain) NSNumber * isChecked;

@end
