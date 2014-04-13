//
//  AssetInfo.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-11.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AssetInfo.h"

@implementation AssetInfo

@synthesize assetID;
@synthesize assetName;
@synthesize assetkind;
@synthesize recentCheckDate;
@synthesize userName;
@synthesize directorName;
@synthesize useDeadline;
@synthesize assetImgUrl;
@synthesize assetImg;

-(AssetInfo *)initWithData
{
    AssetInfo *tmp = [[AssetInfo alloc] init];
    //if(dic == NULL)
   // {
        int i = arc4random() % 5 ;
        tmp.assetID = [NSString stringWithFormat:@"数量：%d",i];
        tmp.assetName = @"MacBook Pro";
        tmp.assetkind = @"类别：办公电子类";
        tmp.userName = @"使用人：周源";
        tmp.directorName = @"责任人：李四";
        tmp.assetImg = [UIImage imageNamed:@"Icon-Small.png"];
   // }
    
    return tmp;
}
@end
