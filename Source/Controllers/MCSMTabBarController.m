//
//  MCSMTabBarViewController.m
//  MCSMUIKit
//
//  Created by Spencer MacDonald on 20/07/2012.
//  Copyright (c) 2012 Square Bracket Software. All rights reserved.
//

#import "MCSMTabBarController.h"
#import "MCSMTabBarItemView.h"

@implementation MCSMTabBarController

@synthesize tabBarControllerDataSource = tabBarControllerDataSource_;
@synthesize tabBarControllerDelegate = tabBarControllerDelegate_;
@synthesize tabBarPosition = tabBarPosition_;

@synthesize viewControllers = viewControllers_;

@synthesize tabBar = tabBar_;
@synthesize tabBarHidden = tabBarHidden_;

@synthesize obeysHidesBottomBarWhenPushed = obeysHidesBottomBarWhenPushed_;

- (id)init{
    
    if((self = [super init])){
        tabBarPosition_ = MCSMTabBarControllerTabBarPositionBottom;
        obeysHidesBottomBarWhenPushed_ = YES;
    }
    
    return self;
}

- (id)initWithTabBar:(MCSMTabBar *)tabBar{
    
    if((self = [self init])){
        [self setTabBar:tabBar];
    }
    
    return self;
}


- (id)initWithStyle:(MCSMTabBarStyle)style{
    
    MCSMTabBar *tabBar = [[MCSMTabBar alloc] initWithStyle:style];
    tabBar.tabBarDataSource = (id<MCSMTabBarDataSource>)self;
    tabBar.tabBarDelegate = (id<MCSMTabBarDelegate>)self;
    
    if((self = [self initWithTabBar:tabBar])){
        
    }
    
    [tabBar release];
    return self;
}

- (void)dealloc{
    
    for (UIViewController *viewController in self.childViewControllers) {
        [viewController removeFromParentViewController];
    }
    
    [viewControllers_ release], viewControllers_ = nil;
    [tabBar_ release], tabBar_ = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return UIDeviceOrientationIsValidInterfaceOrientation(interfaceOrientation);
}

- (void)setViewControllers:(NSArray *)viewControllers{
    
    for(UIViewController *viewController in viewControllers_){
        [viewController removeFromParentViewController]; 
    }
    
    [viewControllers_ release];
    viewControllers_ = [viewControllers retain];
    
    for(UIViewController *viewController in viewControllers_){
        
        if([viewController isKindOfClass:[UINavigationController class]])
        {
            BOOL shouldBecomeDelegateOfNavigationController = YES;
            UINavigationController *navigationController = (UINavigationController *)viewController;
            
            if([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:shouldBecomeDelegateOfNavigationController:)]
               && [navigationController.delegate isEqual:self] == NO)
            {
                shouldBecomeDelegateOfNavigationController = [self.tabBarControllerDelegate tabBarController:self shouldBecomeDelegateOfNavigationController:navigationController];
            }
            
            if(shouldBecomeDelegateOfNavigationController)
            {
                navigationController.delegate = (id<UINavigationControllerDelegate>)self;
            }
        }
    }

    for (UIViewController *viewController in viewControllers_) {
        [self addChildViewController:viewController];
    }
    
    if([self isViewLoaded])
    {
        [self.tabBar reloadTabs];
        
        for(UIViewController *viewController in self.viewControllers){
            [viewController.view removeFromSuperview];
        }
        
        UIViewController *viewController = [self.viewControllers objectAtIndex:self.selectedIndex];
        CGRect viewControllerViewBounds = self.view.bounds;
        
        if(!self.tabBarHidden)
        {
            viewControllerViewBounds.size.height -= self.tabBar.frame.size.height;
            
            if(self.tabBarPosition == MCSMTabBarControllerTabBarPositionTop)
            {
                viewControllerViewBounds.origin.y = self.tabBar.frame.size.height;
            }
        }
        
        [viewController.view setFrame:viewControllerViewBounds];
        viewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        [self.view addSubview:viewController.view];
    }
}



- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated{
    [self setViewControllers:viewControllers];
}

- (void)setTabBarHidden:(BOOL)hidden{
    [self setTabBarHidden:hidden animated:YES];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated{
 
    if(hidden)
    {
        [UIView animateWithDuration:(animated ? UINavigationControllerHideShowBarDuration : 0) 
                         animations:^{
                             
                             UIViewController *viewController = [self.viewControllers objectAtIndex:self.selectedIndex];
                             CGRect viewControllerViewBounds = self.view.bounds;
                             [viewController.view setFrame:viewControllerViewBounds];
                             
                             CGRect tabBarFrame =  self.tabBar.frame;
                             tabBarFrame.origin.x = 0;
                             tabBarFrame.origin.y = self.view.bounds.size.height;
                             tabBarFrame.size.width = self.view.bounds.size.width;
                             self.tabBar.frame = tabBarFrame;
                             
                             [self.view bringSubviewToFront:self.tabBar];
                             
                         }];
        
        tabBarHidden_ = YES;
        
    }else{
        
        [UIView animateWithDuration:(animated ? UINavigationControllerHideShowBarDuration : 0)
                         animations:^{
                             
                             UIViewController *viewController = [self.viewControllers objectAtIndex:self.selectedIndex];
                             
                             CGRect viewControllerViewBounds = self.view.bounds;
                             viewControllerViewBounds.size.height -= self.tabBar.frame.size.height;
                             
                             if(self.tabBarPosition == MCSMTabBarControllerTabBarPositionTop)
                             {
                                 viewControllerViewBounds.origin.y = self.tabBar.frame.size.height;
                             }
                             
                             [viewController.view setFrame:viewControllerViewBounds];
                             
                             CGRect tabBarFrame = self.tabBar.frame;
                             tabBarFrame.origin.x = 0;
                             
                             if(self.tabBarPosition == MCSMTabBarControllerTabBarPositionBottom)
                             {
                                 tabBarFrame.origin.y = self.view.bounds.size.height - self.tabBar.frame.size.height;
                             }else{
                                 tabBarFrame.origin.y = 0;
                                 
                             }
                             tabBarFrame.size.width = self.view.bounds.size.width;
                             self.tabBar.frame = tabBarFrame;
                             
                             [self.view bringSubviewToFront:self.tabBar];
                         }];
        
        tabBarHidden_ = NO;
        
    }
}

- (UIViewController *)selectedViewController{
    return [self.viewControllers objectAtIndex:[self selectedIndex]];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController{
    NSUInteger index = [self.viewControllers indexOfObject:selectedViewController];
    [self setSelectedIndex:index];
}

- (NSUInteger)selectedIndex{
    return [self.tabBar selectedTabIndex];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [self.tabBar setSelectedTabIndex:selectedIndex];
}

- (MCSMTabBar *)tabBar{
    
    if(!tabBar_)
    {
        MCSMTabBar *tabBar = [[MCSMTabBar alloc] initWithStyle:MCSMTabBarStyleDefault];
        tabBar.tabBarDataSource = (id<MCSMTabBarDataSource>)self;
        tabBar.tabBarDelegate = (id<MCSMTabBarDelegate>)self;
        [self setTabBar:tabBar];
        [tabBar release];
    }
    
    return tabBar_;
}

- (void)setTabBar:(MCSMTabBar *)tabBar{
    
    [tabBar_ removeFromSuperview],[tabBar_ release];
    tabBar_ = [tabBar retain];
    
    if([self isViewLoaded])
    {
        
        CGRect tabBarFrame =  self.tabBar.frame;
        
        if(tabBarFrame.size.height == 0)
        {
            tabBarFrame.size.height = 44;
        }
        
        if(self.tabBarPosition == MCSMTabBarControllerTabBarPositionBottom)
        {
            tabBarFrame.origin.y = self.view.frame.size.height - tabBarFrame.size.height;
            self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            
        }else{
            tabBarFrame.origin.y = 0;
            self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        }
        
        tabBarFrame.size.width = self.view.frame.size.width;
        self.tabBar.frame = tabBarFrame;
        [self.view addSubview:self.tabBar];
        
        [self.tabBar reloadTabs];
        
        for(UIViewController *viewController in self.viewControllers){
            [viewController.view removeFromSuperview];
        }
        
        UIViewController *viewController = [self.viewControllers objectAtIndex:self.selectedIndex];
        CGRect viewControllerViewBounds = self.view.bounds;
        
        if(!self.tabBarHidden)
        {
            viewControllerViewBounds.size.height -= self.tabBar.frame.size.height;
            
            if(self.tabBarPosition == MCSMTabBarControllerTabBarPositionTop)
            {
                viewControllerViewBounds.origin.y = self.tabBar.frame.size.height;
            }
        }
        
        [viewController.view setFrame:viewControllerViewBounds];
        viewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        [self.view addSubview:viewController.view];
    }else{
        
        CGRect tabBarFrame = self.tabBar.frame;
        
        if(tabBarFrame.size.height == 0)
        {
            tabBarFrame.size.height = 44;
        }
        
        if(self.tabBarPosition == MCSMTabBarControllerTabBarPositionBottom)
        {
            tabBarFrame.origin.y = self.view.frame.size.height - tabBarFrame.size.height;
            self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            
        }else{
            tabBarFrame.origin.y = 0;
            self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        }
        
        self.tabBar.frame = tabBarFrame;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    CGRect tabBarFrame =  self.tabBar.frame;
    
    if(self.tabBarPosition == MCSMTabBarControllerTabBarPositionBottom)
    {
        tabBarFrame.origin.y = self.view.frame.size.height - tabBarFrame.size.height;
        self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    }else{
        tabBarFrame.origin.y = 0;
        self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    }
    
    tabBarFrame.size.width = self.view.frame.size.width;
    self.tabBar.frame = tabBarFrame;
    [self.view addSubview:self.tabBar];
    
    UIViewController *viewController = [self.viewControllers objectAtIndex:self.selectedIndex];
    CGRect viewControllerViewBounds = self.view.bounds;
    viewControllerViewBounds.size.height -= tabBarFrame.size.height;
    
    if(self.tabBarPosition == MCSMTabBarControllerTabBarPositionTop)
    {
        viewControllerViewBounds.origin.y = tabBarFrame.size.height;
    }
    
    [viewController.view setFrame:viewControllerViewBounds];
    viewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:viewController.view];
}

#pragma mark -
#pragma mark UINavigationController

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:navigationController:willShowViewController:animated:)])
    {
        [self.tabBarControllerDelegate tabBarController:self 
                                   navigationController:navigationController 
                                 willShowViewController:viewController 
                                               animated:animated];
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:navigationController:didShowViewController:animated:)])
    {
        [self.tabBarControllerDelegate tabBarController:self 
                                   navigationController:navigationController 
                                 didShowViewController:viewController 
                                               animated:animated];
    }
    
    if(self.obeysHidesBottomBarWhenPushed)
    {    
        if([viewController hidesBottomBarWhenPushed])
        {
            [self setTabBarHidden:YES animated:animated];
            
        }else{
            [self setTabBarHidden:NO animated:animated];
        }
    }
}


#pragma mark -
#pragma mark MCSMTabBarDataSource

- (NSUInteger)numberOfTabsInTabBar:(MCSMTabBar *)tabBar{
    return [self.viewControllers count];
}


- (MCSMTabBarItemView *)tabBar:(MCSMTabBar *)tabBar tabBarItemViewForTabAtIndex:(NSUInteger)index{
    
    MCSMTabBarItemView *tabBarItemView = nil;
    
    if([self.tabBarControllerDataSource respondsToSelector:@selector(tabBarController:tabBarItemViewForViewController:)])
    {
        UIViewController *viewController = [self.viewControllers objectAtIndex:index];
        tabBarItemView = [self.tabBarControllerDataSource tabBarController:self tabBarItemViewForViewController:viewController];
    }else if([[self.viewControllers objectAtIndex:index] tabBarItem]){
        
        UITabBarItem *tabBarItem = [[self.viewControllers objectAtIndex:index] tabBarItem];
        
        tabBarItemView = [[[MCSMTabBarItemView alloc] initWithStyle:self.tabBar.style] autorelease];
        
        [tabBarItemView setTitle:tabBarItem.title];
        
        if(tabBarItem.finishedUnselectedImage && tabBarItem.finishedSelectedImage)
        {
            [tabBarItemView setImage:tabBarItem.finishedUnselectedImage];
            [tabBarItemView setSelectedImage:tabBarItem.finishedUnselectedImage];
        }else if(tabBarItem.image)
        {
            [tabBarItemView setUnfinishedImage:tabBarItem.image];
        }

    }
    
    return tabBarItemView;
    
}

#pragma mark -
#pragma mark MCSMTabBarDelegate

- (CGFloat)tabBar:(MCSMTabBar *)tabBar widthForTabAtIndex:(NSInteger)index{
    
    CGFloat tabWidth = MCSMTabBarAutomaticDimension;
    
    if([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:tabBar:widthForTabAtIndex:)])
        
    {
        tabWidth = [self.tabBarControllerDelegate tabBarController:self tabBar:tabBar widthForTabAtIndex:index];
    }
        
    return tabWidth;
}

- (BOOL)tabBar:(MCSMTabBar *)tabBar shouldSelectTabAtIndex:(NSUInteger)index{
    
    BOOL shouldSelectTabAtIndex = YES;
    
    if([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
        UIViewController *viewController = [self.viewControllers objectAtIndex:index];
        shouldSelectTabAtIndex = [self.tabBarControllerDelegate tabBarController:self shouldSelectViewController:viewController];
    }
    
    return shouldSelectTabAtIndex;
}

- (void)tabBar:(MCSMTabBar *)tabBar didSelectTabAtIndex:(NSUInteger)index{
    
    for(UIViewController *viewController in self.viewControllers){
        [viewController.view removeFromSuperview];
    }
            
    UIViewController *viewController = [self.viewControllers objectAtIndex:self.selectedIndex];
    CGRect viewControllerViewBounds = self.view.bounds;
    
    if(!self.tabBarHidden)
    {
        viewControllerViewBounds.size.height -= self.tabBar.frame.size.height;

        if(self.tabBarPosition == MCSMTabBarControllerTabBarPositionTop)
        {
            viewControllerViewBounds.origin.y = self.tabBar.frame.size.height;
        }
    }
    
    [viewController.view setFrame:viewControllerViewBounds];
    viewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:viewController.view];
        
    if([self.tabBarControllerDelegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [self.tabBarControllerDelegate tabBarController:self didSelectViewController:viewController];
    }
}

@end
