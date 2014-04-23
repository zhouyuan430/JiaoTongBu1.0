//
//  ContactInfoCell.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-13.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "ContactInfoCell.h"

@implementation ContactInfoCell

@synthesize nameLabel;
@synthesize phoneLabel;
@synthesize emailLabel;
@synthesize addressLabel;
@synthesize departmentLabel;

@synthesize peopleImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellInfo:(ContactInfo *)_info
{
    self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",_info.nameLabel];
    self.emailLabel.text = [NSString stringWithFormat:@"email：%@",_info.emailLabel];
    self.departmentLabel.text = _info.departmentLabel;
}

@end
