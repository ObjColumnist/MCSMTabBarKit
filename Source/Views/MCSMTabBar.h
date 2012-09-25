//
//  MCSMTabBar.h
//  MCSMUIKit
//
//  Created by Spencer MacDonald on 20/07/2012.
//  Copyright (c) 2012 Square Bracket Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCSMTabBarItemView;

@protocol MCSMTabBarDataSource;
@protocol MCSMTabBarDelegate;


extern const CGFloat MCSMTabBarAutomaticDimension;

typedef enum MCSMTabBarStyle : NSUInteger{
    MCSMTabBarStyleCustom,
    MCSMTabBarStyleDefault
} MCSMTabBarStyle;

@interface MCSMTabBar : UIView

@property (nonatomic,assign) id <MCSMTabBarDataSource> tabBarDataSource;
@property (nonatomic,assign) id <MCSMTabBarDelegate> tabBarDelegate;

@property (nonatomic,assign) NSUInteger selectedTabIndex;
@property (nonatomic,retain) UIView *backgroundView;

@property (nonatomic,assign, readonly) MCSMTabBarStyle style;

- (id)initWithStyle:(MCSMTabBarStyle)style;

- (void)reloadTabs;
- (void)reloadTabAtIndex:(NSUInteger)index;

@end

@protocol MCSMTabBarDataSource <NSObject>

@required
- (NSUInteger)numberOfTabsInTabBar:(MCSMTabBar *)tabBar;
- (MCSMTabBarItemView *)tabBar:(MCSMTabBar *)tabBar tabBarItemViewForTabAtIndex:(NSUInteger)index;

@end

@protocol MCSMTabBarDelegate <NSObject>

@optional
- (BOOL)tabBar:(MCSMTabBar *)tabBar shouldSelectTabAtIndex:(NSUInteger)index;
- (void)tabBar:(MCSMTabBar *)tabBar didSelectTabAtIndex:(NSUInteger)index;
- (CGFloat)tabBar:(MCSMTabBar *)tabBar widthForTabAtIndex:(NSInteger)index;

@end

