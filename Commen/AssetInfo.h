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
@property (strong, nonatomic) NSString *assetCount;
@property (strong, nonatomic) NSString *assetName;
@property (strong, nonatomic) NSString *assetCate;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *useDepartment;
@property (strong, nonatomic) NSString *assetImgPath;
@property (strong, nonatomic) UIImage  *assetImg;
@property (strong, nonatomic) NSString *assetValue;
@property (strong, nonatomic) NSString *assetCardID;
@property (strong, nonatomic) NSString *upLoadPath;
@property (strong, nonatomic) NSString *useOffice;
@property (strong, nonatomic) NSString *id_useOffice;

-(AssetInfo *)initWithData:(NSDictionary *)dic;

-(AssetInfo *)initWithCheckData:(NSDictionary *)dic;
@end
