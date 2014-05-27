//
//  Toolbar.m
//  YingYingLiCai
//
//  Created by JianYe on 13-6-6.
//  Copyright (c) 2013年 YingYing. All rights reserved.
//

#import "Navbar.h"

@interface Navbar()
@property (nonatomic,strong)NSNumber *stateBarStyle;
@end

@implementation Navbar
@synthesize stateBarColor = _stateBarColor;
@synthesize stateBarStyle = _stateBarStyle;
NSString * gNavbarBackgroundImageName = @"NavigationBar.png";

- (void)drawRect:(CGRect)rect
{
    if (gNavbarBackgroundImageName != nil) {
        [[UIImage imageNamed:gNavbarBackgroundImageName] drawInRect:rect];
    }
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
    
    self.barStyle = (_stateBarStyle)?[_stateBarStyle integerValue]:DefaultStateBarSytle;
    UIView *view = [self viewWithTag:99900];
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.bounds.size.width, 20)];
        view.backgroundColor = (_stateBarColor)?_stateBarColor:DefaultStateBarColor;
        [self addSubview:view];
    }
    
    /**< 起到在IOS 7中navbar 和state bar 不 悬浮的作用*/
    self.translucent = NO;
    
    self.tintColor = [UIColor clearColor];
}

- (void)setStateBarColor:(UIColor *)stateBarColor
{
    _stateBarColor = stateBarColor;
    UIView *view = [self viewWithTag:99900];
    if (!view&&stateBarColor) {
        [self setNeedsLayout];
    }
}

- (void)setCusBarStyele:(UIBarStyle)cusBarStyele
{
    _stateBarStyle = [NSNumber numberWithInteger:cusBarStyele];
    [self setNeedsLayout];
}

- (void)setDefault
{
    self.stateBarColor = DefaultStateBarColor;
    self.cusBarStyele = DefaultStateBarSytle;
}
@end





@implementation NavBarButtonItem

@synthesize itemType = _itemType;
@synthesize button = _button;
@synthesize title = _title;
@synthesize image = _image;
@synthesize font = _font;
@synthesize normalColor = _normalColor;
@synthesize selectedColor = _selectedColor;
@synthesize selector = _selector;
@synthesize target = _target;
@synthesize highlightedWhileSwitch = _highlightedWhileSwitch;
- (void)dealloc {
    
    self.target = nil;
    self.selector = nil;
}

- (id)initWithType:(NavBarButtonItemType)itemType
{
    self = [super init];
    if (self) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button  = button;
        self.itemType = itemType;
        button.titleLabel.font  = [UIFont systemFontOfSize:ItemTextFont];
        [button setTitleColor:ItemTextNormalColot forState:UIControlStateNormal];
        
        [button setTitleColor:ItemTextSelectedColot forState:UIControlStateHighlighted];
        [button setTitleColor:ItemTextSelectedColot forState:UIControlStateSelected];
        button.frame =CGRectMake(0, 0, ItemWidth, ItemHeight);
    }
    return self;
}

+ (id)defauleItemWithTarget:(id)target
                     action:(SEL)action
                      title:(NSString *)title
{
    NavBarButtonItem *item = [[NavBarButtonItem alloc]initWithType:NavBarButtonItemTypeDefault];
    item.title = title;
    [item setTarget:target withAction:action];
    return item;
}

+ (id)defauleItemWithTarget:(id)target
                     action:(SEL)action
                      image:(NSString *)image
{
    NavBarButtonItem *item = [[NavBarButtonItem alloc]initWithType:NavBarButtonItemTypeDefault];
    item.image = image;
    [item setTarget:target withAction:action];
    return item;
}

+ (id)backItemWithTarget:(id)target
                    action:(SEL)action
                     title:(NSString *)title
{
    NavBarButtonItem *item = [[NavBarButtonItem alloc] initWithType:NavBarButtonItemTypeBack];
    item.title = title;
    [item setTarget:target withAction:action];
    return item;
}

- (void)setItemType:(NavBarButtonItemType)itemType
{
    _itemType = itemType;
    UIImage *image;
    UIImage *image_s;
    switch (itemType) {
        case NavBarButtonItemTypeBack:
        {
            image = [self imageWithImage:[UIImage imageNamed:@"BackButton"] CGSize:CGSizeMake(12, 30)];
            image_s = [self imageWithImage:[UIImage imageNamed:@"BackButton"] CGSize:CGSizeMake(12, 30)];
        }
            break;
        case NavBarButtonItemTypeDefault:
        {
            image = [UIImage imageNamed:ItemImage];
            image_s = [UIImage imageNamed:ItemSelectedImage];
        }
            break;
        default:
            break;
    }
    
    [_button setBackgroundImage:image forState:UIControlStateNormal];
    [_button setBackgroundImage:image_s forState:UIControlStateHighlighted];
    [_button setBackgroundImage:image_s forState:UIControlStateSelected];
    
    [self  titleOffsetWithType];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [_button setTitle:title forState:UIControlStateNormal];
    [_button setTitle:title forState:UIControlStateHighlighted];
    [_button setTitle:title forState:UIControlStateSelected];
    
    [self  titleOffsetWithType];
}

- (void)setImage:(NSString *)image
{
    _image = image;
    UIImage *image_ = [self imageWithImage:[UIImage imageNamed:image] CGSize:CGSizeMake(8, 30)];//[UIImage imageNamed:image];
    [_button setImage:image_  forState:UIControlStateNormal];
    [_button setImage:image_ forState:UIControlStateHighlighted];
    [_button setImage:image_ forState:UIControlStateSelected];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    [_button.titleLabel setFont:font];
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    [_button setTitleColor:normalColor forState:UIControlStateNormal];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    [_button setTitleColor:selectedColor forState:UIControlStateHighlighted];
    [_button setTitleColor:selectedColor forState:UIControlStateSelected];
}

- (void)setTarget:(id)target withAction:(SEL)action
{
    [_button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


- (void)titleOffsetWithType
{
    switch (_itemType) {
        case NavBarButtonItemTypeBack:
        {
            [_button setContentEdgeInsets:BackItemOffset];
        }
            break;
        case NavBarButtonItemTypeDefault:
        {
            [_button setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
            break;
        default:
            break;
    }
}

- (void)setHighlightedWhileSwitch:(BOOL)highlightedWhileSwitch
{
    UIImage *image;
    if (!highlightedWhileSwitch) {
       
        switch (_itemType) {
            case NavBarButtonItemTypeBack:
            {
                image = [self imageWithImage:[UIImage imageNamed:@"BackButton"] CGSize:CGSizeMake(12, 30)];
            }
                break;
            case NavBarButtonItemTypeDefault:
            {
                image = [UIImage imageNamed:ItemImage];
                
            }
                break;
            default:
                break;
        }
    }else
        {
            switch (_itemType) {
                case NavBarButtonItemTypeBack:
                {
                    image = [self imageWithImage:[UIImage imageNamed:@"BackButton"] CGSize:CGSizeMake(12, 30)];
                }
                    break;
                case NavBarButtonItemTypeDefault:
                {
                    image = [UIImage imageNamed:ItemSelectedImage];
                    
                }
                    break;
                default:
                    break;
        }
    }
    [_button setBackgroundImage:image forState:UIControlStateNormal];
    [_button setBackgroundImage:image forState:UIControlStateHighlighted];
    [_button setBackgroundImage:image forState:UIControlStateSelected];
}


//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image CGSize:(CGSize)Size
{
    UIGraphicsBeginImageContext(CGSizeMake(ItemWidth, ItemHeight));
    if (Size.width == 8) {
        [image drawInRect:CGRectMake(10,5,Size.width,Size.height)];
    }
    else{
        [image drawInRect:CGRectMake(0,5,Size.width,Size.height)];
    }
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



@end



@implementation UINavigationItem(CustomBarButtonItem)

- (void)setNewTitle:(NSString *)title
{
      
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 180, 20);
    label.backgroundColor = [UIColor clearColor];
    label.tag = 99901;
    label.font = [UIFont systemFontOfSize:TitleFont];
    label.textColor = TitleColor;
    label.textAlignment = NSTextAlignmentCenter;//  kTextAlignmentCenter;
    label.text = title;
    self.titleView = label;

}

- (void)setNewTitleImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    CGRect bounds = imageView.bounds;
    imageView.tag = 99902;
    bounds.size  =  image.size;
    imageView.bounds = bounds;
    self.titleView = imageView;
}





- (void)setLeftItemWithTarget:(id)target
                       action:(SEL)action
                        title:(NSString *)title
{
    NavBarButtonItem *buttonItem = [NavBarButtonItem defauleItemWithTarget:target
                                                                    action:action
                                                                     title:title];
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
}

- (void)setLeftItemWithTarget:(id)target
                       action:(SEL)action
                        image:(NSString *)image
{
    NavBarButtonItem *buttonItem = [NavBarButtonItem defauleItemWithTarget:target
                                                                    action:action
                                                                     image:image];
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
}

- (void)setLeftItemWithButtonItem:(NavBarButtonItem *)item
{
     self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item.button];
}




- (void)setRightItemWithTarget:(id)target
                        action:(SEL)action
                         title:(NSString *)title
{
    NavBarButtonItem *buttonItem = [NavBarButtonItem defauleItemWithTarget:target
                                                                    action:action
                                                                     title:title];
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
}

- (void)setRightItemWithTarget:(id)target
                        action:(SEL)action
                         image:(NSString *)image
{
    NavBarButtonItem *buttonItem = [NavBarButtonItem defauleItemWithTarget:target
                                                                    action:action
                                                                     image:image];
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
}

- (void)setRightItemWithButtonItem:(NavBarButtonItem *)item
{
     self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item.button];
}


- (void)setBackItemWithTarget:(id)target
                       action:(SEL)action

{
    NavBarButtonItem *buttonItem = [NavBarButtonItem backItemWithTarget:target
                                                                 action:action
                                                                  title:@""];
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
}

- (void)setBackItemWithTarget:(id)target
                       action:(SEL)action
                        title:(NSString *)title
{
    NavBarButtonItem *buttonItem = [NavBarButtonItem backItemWithTarget:target
                                                                 action:action
                                                                  title:title];
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonItem.button];
}

-(void)setRightItemsWithTarget:(id)target
                       action1:(SEL)action1
                       action2:(SEL)action2
                        title1:(NSString *)title1
                        title2:(NSString *)title2
{
    NavBarButtonItem *buttonItem1 = [NavBarButtonItem defauleItemWithTarget:target
                                                                    action:action1
                                                                     title:title1];
    NavBarButtonItem *buttonItem2 = [NavBarButtonItem defauleItemWithTarget:target
                                                                    action:action2
                                                                     title:title2];

    self.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:buttonItem1.button],[[UIBarButtonItem alloc] initWithCustomView:buttonItem2.button]];
}

@end


