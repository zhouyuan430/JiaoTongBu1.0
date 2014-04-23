//
//  ContactInfoCell.h
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-13.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactInfo.h"
#import "ContactInfoCell.h"
@interface ContactInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;

@property (strong, nonatomic) IBOutlet UIImageView *peopleImg;


-(void)setCellInfo:(ContactInfo *)_info;

@end
