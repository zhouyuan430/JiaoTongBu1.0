//
//  CheckAssetInfo.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-12.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetInfo.h"
@interface CheckAssetInfo : AssetInfo

@property (strong, nonatomic) NSString *checkFlag;


-(CheckAssetInfo *)initWithCheckData:(NSDictionary *)dic;

@end
