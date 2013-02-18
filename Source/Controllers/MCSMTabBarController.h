//
//  MCSMTabBarViewController.h
//  MCSMUIKit
//
//  Created by Spencer MacDonald on 20/07/2012.
//  Copyright (c) 2012 Square Bracket Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSMTabBar.h"

@class MCSMTabBar;
@class MCSMTabBarItemView;

@protocol MCSMTabBarControllerDataSource;
@protocol MCSMTabBarControllerDelegate;

typedef enum MCSMTabBarControllerTabBarPosition : NSUInteger{
    MCSMTabBarControllerTabBarPositionBottom,
    MCSMTabBarControllerTabBarPositionTop
}MCSMTabBarControllerTabBarPosition;


typedef enum MCSMTabBarControllerTabBarShowHideDirection : NSUInteger{
    MCSMTabBarControllerTabBarShowHideDirectionTopToBottom,
    MCSMTabBarControllerTabBarShowHideDirectionBottomToTop,
    MCSMTabBarControllerTabBarShowHideDirectionLeftToRight,
    MCSMTabBarControllerTabBarShowHideDirectionRightToLeft
}MCSMTabBarControllerTabBarShowHideDirection;

@interface MCSMTabBarController : UIViewController <MCSMTabBarDataSource, MCSMTabBarDelegate>

@property (nonatomic,assign) id <MCSMTabBarControllerDataSource> tabBarControllerDataSource;

@property (nonatomic,assign) id <MCSMTabBarControllerDelegate> tabBarControllerDelegate;
@property (nonatomic,assign) MCSMTabBarControllerTabBarPosition tabBarPosition;

@property (nonatomic,retain) NSArray *viewControllers;

@property (nonatomic,retain) UIViewController *selectedViewController;
@property (nonatomic,assign) NSUInteger selectedIndex;

@property (nonatomic,retain) MCSMTabBar *tabBar;
@property (nonatomic,assign, getter = isTabBarHidden) BOOL tabBarHidden;
@property (nonatomic,assign, getter = isTabBarAnimating,readonly) BOOL tabBarAnimating;

@property (nonatomic,assign) BOOL obeysHidesBottomBarWhenPushed;

- (id)initWithTabBar:(MCSMTabBar *)tabBar;
- (id)initWithStyle:(MCSMTabBarStyle)style;

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setTabBarHidden:(BOOL)hidden direction:(MCSMTabBarControllerTabBarShowHideDirection)direction animated:(BOOL)animated completion:(void (^)(void))completion;

@end

@protocol MCSMTabBarControllerDataSource <NSObject>

@optional

- (MCSMTabBarItemView *)tabBarController:(MCSMTabBarController *)tabBarController tabBarItemViewForViewController:(UIViewController *)viewController;

- (NSString *)tabBarController:(MCSMTabBarController *)tabBarController titleForViewController:(UIViewController *)viewController;

- (UIImage *)tabBarController:(MCSMTabBarController *)tabBarController imageForViewController:(UIViewController *)viewController;
- (UIImage *)tabBarController:(MCSMTabBarController *)tabBarController selectedImageForViewController:(UIViewController *)viewController;
- (UIImage *)tabBarController:(MCSMTabBarController *)tabBarController unfinishedImageForViewController:(UIViewController *)viewController;

@end

@protocol MCSMTabBarControllerDelegate <NSObject>

@optional

- (CGFloat)tabBarController:(MCSMTabBarController *)tabBarController widthForTabAtIndex:(NSInteger)index;

- (BOOL)tabBarController:(MCSMTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(MCSMTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

- (BOOL)tabBarController:(MCSMTabBarController *)tabBarController shouldBecomeDelegateOfNavigationController:(UINavigationController *)navigationController;

- (void)tabBarController:(MCSMTabBarController *)tabBarController navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)tabBarController:(MCSMTabBarController *)tabBarController navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;


@end