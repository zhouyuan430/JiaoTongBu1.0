//
//  JiaoTongBuClient.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-20.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "MessageBox.h"

typedef void(^completCallBack) (int flag,NSDictionary *dic,NSError *error) ;

@interface JiaoTongBuClient : AFHTTPRequestOperationManager
{
    MessageBox *HHUD;
}
+(instancetype)sharedClient;

-(NSDictionary *)XMLParser:(NSData *)data;

-(void)startGet:(NSInteger)_code parameters:(NSDictionary*)para withCallBack:(completCallBack)callBack;

-(void)startPost:(NSInteger)_code parameters:(NSDictionary*)para withCallBack:(completCallBack)callBack;

@end
