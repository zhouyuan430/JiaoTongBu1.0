//
//  AssetDirectCheck.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-24.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PersonAsset.h"


@interface AssetDirectCheck : PersonAsset

@property (nonatomic, retain) NSNumber * checkFlag;

-(void)initCheckData:(NSDictionary *)data;


@end
