//
//  AssetInfo.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetInfo : NSObject
{
    
}
@property (strong, nonatomic) NSString *assetID;
@property (strong, nonatomic) NSString *assetName;
@property (strong, nonatomic) NSString *assetkind;
@property (strong, nonatomic) NSString *recentCheckDate;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *directorName;
@property (strong, nonatomic) NSString *useDeadline;
@property (strong, nonatomic) NSString *assetImgUrl;
@property (strong, nonatomic) UIImage *assetImg;


-(AssetInfo *)initWithData;
@end