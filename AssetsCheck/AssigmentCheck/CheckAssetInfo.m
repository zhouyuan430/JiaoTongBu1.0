//
//  CheckAssetInfo.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-12.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "CheckAssetInfo.h"
#import "AssetInfo.h"
@implementation CheckAssetInfo

@synthesize checkFlag;
-(CheckAssetInfo *)initWithCheckData:(NSDictionary *)dic
{
    CheckAssetInfo *tmp = [[CheckAssetInfo alloc] init];
    if (dic) {
        tmp.assetID = dic[@"id"];
        tmp.assetName = dic[@"assetsName"];
        tmp.assetCate = dic[@"name_assetsBudget"];
        tmp.assetValue = dic[@"assetValue"];
        tmp.userName = dic[@"username"];
        tmp.assetCount = dic[@"num"];
        tmp.directorName = dic[@"name_department"];
        tmp.assetCardID = dic[@"assetsId"];
        tmp.assetImgPath = dic[@"image"];
        tmp.checkFlag = @"0";
    }
    return tmp;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.assetID = [aDecoder decodeObjectForKey:@"assetID"];
        self.assetName = [aDecoder decodeObjectForKey:@"assetName"];
        self.assetCate = [aDecoder decodeObjectForKey:@"assetCate"];
        self.assetValue = [aDecoder decodeObjectForKey:@"assetValue"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.assetCount = [aDecoder decodeObjectForKey:@"assetCount"];
        self.directorName = [aDecoder decodeObjectForKey:@"directorName"];
        self.assetCardID = [aDecoder decodeObjectForKey:@"assetCardID"];
        self.assetImgPath = [aDecoder decodeObjectForKey:@"assetImgPath"];
        self.checkFlag = [aDecoder decodeObjectForKey:@"checkFlag"];

    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    //encode properties/values
    [aCoder encodeObject:self.assetID      forKey:@"assetID"];
    [aCoder encodeObject:self.assetName  forKey:@"assetName"];
    [aCoder encodeObject:self.assetCate      forKey:@"assetCate"];
    [aCoder encodeObject:self.assetValue     forKey:@"assetValue"];
    [aCoder encodeObject:self.userName     forKey:@"userName"];
    [aCoder encodeObject:self.assetCount     forKey:@"assetCount"];
    [aCoder encodeObject:self.directorName     forKey:@"directorName"];
    [aCoder encodeObject:self.assetCardID     forKey:@"assetCardID"];
    [aCoder encodeObject:self.assetImgPath     forKey:@"assetImgPath"];
    [aCoder encodeObject:self.checkFlag     forKey:@"checkFlag"];

}


@end
