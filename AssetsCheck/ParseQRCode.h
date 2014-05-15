//
//  ParseQRCode.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-9.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseQRCode : NSObject
{
    
}

@property (strong, nonatomic) NSMutableDictionary *parseInfo;
@property (strong, nonatomic) NSString *assetName;
@property (strong, nonatomic) NSString *assetCardID;
@property (strong, nonatomic) NSString *assetID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *assetCate;
@property (strong, nonatomic) NSString *assetNum;

-(ParseQRCode *)initWithData:(NSString *)str;

@end
