//
//  ParseQRCode.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-9.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "ParseQRCode.h"

@implementation ParseQRCode

@synthesize parseInfo;


-(ParseQRCode *)initWithData:(NSString *)str
{
    str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    ParseQRCode *tmp = [[ParseQRCode alloc] init];
    tmp.parseInfo = [[NSMutableDictionary alloc] init];
    int begin = 0;
    NSString *key, *object;
    for (int i = 0;i < str.length; i++)
    {
        char t = [str characterAtIndex:i];
        if (t == '=') {
            
            key = [str substringWithRange:NSMakeRange(begin, i - begin)];
            
            begin = i+1;
            while ([str characterAtIndex:i] != ',') {
                i++;
                if (i == str.length) {
                    break;
                }
            }
            object = [str substringWithRange:NSMakeRange(begin, i - begin)];
            begin = i+1;
            
            [tmp.parseInfo setObject:object forKey:key];
        }
    }
    return tmp;
}


@end
