//
//  CloCombox.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-5-8.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "CloCombox.h"

@implementation CloCombox
@synthesize delegate, tableItems;
@synthesize titleLable;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items inView:(UIView *)view{
    self = [self initWithFrame:frame];
    self.tableItems = items;
    title = [UIButton buttonWithType:UIButtonTypeSystem];
    [title setFrame:CGRectMake(0, 0, frame.size.width, 44)];
    [self setTitle:@"名称"];
    
    [title addTarget:self action:@selector(titleBtnDidTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:title];
    
    cloTable = [[UITableView alloc] initWithFrame:CGRectMake((view.frame.size.width - frame.size.width)/2, 0, frame.size.width, 30*items.count) style:UITableViewStylePlain];
    cloTable.delegate = self;
    cloTable.dataSource = self;
    cloTable.dataSource = self;
    cloTable.hidden = YES;
    [view addSubview:cloTable];
    return self;
}

- (void)setTitle:(NSString *)titleStr
{
    [title setTitle:titleStr forState:UIControlStateNormal];
    titleLable = titleStr;
}

- (IBAction)titleBtnDidTaped:(id)sender{
    cloTable.hidden = !cloTable.hidden;
}
#pragma mark-
#pragma table view datasource
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableItems.count;
}
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CELLIDENTIFIER";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //if sdk version is below 6.0 instead by UITextAlignmentCenter
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
    cell.textLabel.text = [tableItems objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark -
#pragma mark tableview delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setTitle:[tableItems objectAtIndex:indexPath.row]];
    tableView.hidden = YES;
    if ([delegate respondsToSelector:@selector(itemDidSelected:)]) {
        [delegate itemDidSelected:indexPath.row];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
