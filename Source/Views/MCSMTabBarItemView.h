//
//  MCSMTabBarItemView.h
//  MCSMUIKit
//
//  Created by Spencer MacDonald on 20/07/2012.
//  Copyright (c) 2012 Square Bracket Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSMTabBar.h"
@class MCSMTabBar;

typedef enum MCSMTabBarItemViewStyle : NSUInteger{
    MCSMTabBarItemViewStyleCustom = MCSMTabBarStyleCustom,
    MCSMTabBarItemViewStyleDefault = MCSMTabBarStyleDefault
} MCSMTabBarItemViewStyle;

@interface MCSMTabBarItemView : UIView

@property (nonatomic,retain) UILabel *textLabel;
@property (nonatomic,retain) UIImageView *imageView;

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) UIView *selectedBackgroundView;


@property (nonatomic,copy) NSString *title;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) UIImage *selectedImage;

@property (nonatomic,assign,getter = isSelected) BOOL selected;

@property (nonatomic,assign,readonly) MCSMTabBarItemViewStyle style;

+ (UIImage *)imageForUnfinishedImage:(UIImage *)image style:(MCSMTabBarItemViewStyle)style;
+ (UIImage *)selectedImageForUnfinishedImage:(UIImage *)image style:(MCSMTabBarItemViewStyle)style;

+ (instancetype)tabBarItemViewWithStyle:(MCSMTabBarItemViewStyle)style;

- (id)initWithStyle:(MCSMTabBarItemViewStyle)style;

- (void)setImage:(UIImage *)image selectedImage:(UIImage *)selectedImage;

- (void)setUnfinishedImage:(UIImage *)image;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end

@interface UIImage (MCSMTabBarItemViewAdditions)

- (UIImage *)MCSMTabBarItemView_imageMaskedWithColors:(NSArray *)colors opacity:(CGFloat)opacity;

@end