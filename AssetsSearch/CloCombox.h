//
//  CloCombox.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-8.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol CloComboxDelegate;
@interface CloCombox : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UIButton *title;
    NSString *titleLable;
    UITableView *cloTable;
}
@property (nonatomic, retain) id <CloComboxDelegate> delegate;

@property (nonatomic, retain) NSArray *tableItems;
@property (strong, nonatomic) NSString *titleLable;

- (void)setTitle:(NSString *)titleStr;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items inView:(UIView *)view;
@end

@protocol CloComboxDelegate <NSObject>

- (void)itemDidSelected:(NSInteger)index;

@end
