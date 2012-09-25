//
//  MCSMTabBar.m
//  MCSMUIKit
//
//  Created by Spencer MacDonald on 20/07/2012.
//  Copyright (c) 2012 Square Bracket Software. All rights reserved.
//

#import "MCSMTabBar.h"
#import "MCSMTabBarItemView.h"

const CGFloat MCSMTabBarAutomaticDimension = CGFLOAT_MAX;


@implementation MCSMTabBar{
    UITapGestureRecognizer *tapGestureRecognizer_;
    NSMutableArray *tabBarItemViews_;
}

@synthesize tabBarDataSource = tabBarDataSource_;
@synthesize tabBarDelegate = tabBarDelegate_;
@synthesize selectedTabIndex = selectedTabIndex_;
@synthesize backgroundView = backgroundView_;
@synthesize style = style_;

- (id)initWithFrame:(CGRect)frame{
    
    if((self = [super initWithFrame:frame])){
        
        tapGestureRecognizer_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [tapGestureRecognizer_ setDelegate:(id<UIGestureRecognizerDelegate>)self];
        [self addGestureRecognizer:tapGestureRecognizer_];
        
        tabBarItemViews_ = [[NSMutableArray alloc] init];
        selectedTabIndex_ = 0;
    }
    
    return self;
}

- (id)initWithStyle:(MCSMTabBarStyle)style{
    
    if((self = [self initWithFrame:CGRectZero])){
        
        style_ = style;
        
        if(style_ == MCSMTabBarStyleDefault)
        {
            self.backgroundColor = [UIColor blackColor];
            
            backgroundView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MCSMTabBarDefaultStyleBackground.png"]];
            backgroundView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            backgroundView_.frame = self.bounds;
            [self addSubview:backgroundView_];
        }
        
        
    }
    
    return self;
    
}

- (void)dealloc{
    
    [backgroundView_ release], backgroundView_ = nil;
    [tapGestureRecognizer_ release], tapGestureRecognizer_ = nil;
    [tabBarItemViews_ release], tabBarItemViews_ = nil;
    
    self.tabBarDataSource = nil;
    self.tabBarDelegate = nil;
    
    [super dealloc];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];

    [self reloadTabs];
}

- (void)layoutSubviews{
    [super layoutSubviews];
        
    NSUInteger numberOfTabs = [tabBarItemViews_ count];

    CGFloat originX = 0;
    
    for (NSUInteger i= 0; i < numberOfTabs; i++) {
        MCSMTabBarItemView *tabBarItemView = [tabBarItemViews_ objectAtIndex:i];
        
        CGFloat tabWidth = self.frame.size.width / numberOfTabs;

        if([self.tabBarDelegate respondsToSelector:@selector(tabBar:widthForTabAtIndex:)])
        {
            CGFloat suggestedTabWidth = [self.tabBarDelegate tabBar:self widthForTabAtIndex:i];
            
            if(suggestedTabWidth != MCSMTabBarAutomaticDimension)
            {
                tabWidth = suggestedTabWidth;
            }
        }
        
        tabBarItemView.frame = CGRectMake(originX, 0, tabWidth, self.frame.size.height);
        
        originX += tabWidth;
    }

    if(style_ == MCSMTabBarStyleDefault)
    {
        backgroundView_.frame = self.bounds;
    }
}

- (void)setBackgroundView:(UIView *)backgroundView{
    [backgroundView_ removeFromSuperview], [backgroundView_ release];
    backgroundView_ = [backgroundView retain];
    
    [self insertSubview:backgroundView_ atIndex:0];
    
    [self setNeedsLayout];
}
- (void)setSelectedTabIndex:(NSUInteger)selectedTabIndex{
    
    if(selectedTabIndex_ != selectedTabIndex)
    {
        [self willChangeValueForKey:@"selectedTabIndex"];
        selectedTabIndex_ = selectedTabIndex;
        [self didChangeValueForKey:@"selectedTabIndex"];

        NSUInteger numberOfTabs = [tabBarItemViews_ count];
                
        for (NSUInteger i= 0; i < numberOfTabs; i++) {
            
            MCSMTabBarItemView *tabBarItemView = [tabBarItemViews_ objectAtIndex:i];
            
            if(self.selectedTabIndex == i)
            {
                [tabBarItemView setSelected:YES animated:YES];
            }else{
                [tabBarItemView setSelected:NO animated:YES]; 
            }
        }
        
        [self.tabBarDelegate tabBar:self didSelectTabAtIndex:selectedTabIndex];
    }
}

- (void)reloadTabs{
    
    if([self superview] && [self tabBarDataSource])
    {
        for(MCSMTabBarItemView *tabBarItemView in tabBarItemViews_){
            [tabBarItemView removeFromSuperview];
        }
        
        [tabBarItemViews_ removeAllObjects];
        
        NSUInteger numberOfTabs = [self.tabBarDataSource numberOfTabsInTabBar:self];
        
        if(self.selectedTabIndex > numberOfTabs)
        {
            self.selectedTabIndex = 0;
        }
                
        
        
        for (NSUInteger i= 0; i < numberOfTabs; i++) {
                        
            MCSMTabBarItemView *tabBarItemView = [self.tabBarDataSource tabBar:self tabBarItemViewForTabAtIndex:i];
                                                
            [tabBarItemViews_ addObject:tabBarItemView];
            
            [self addSubview:tabBarItemView];
            
            if(self.selectedTabIndex == i)
            {
                [tabBarItemView setSelected:YES animated:YES];
            }else{
                [tabBarItemView setSelected:NO animated:YES]; 
            }
        }
        
        [self setNeedsLayout];
    }
    
}

- (void)reloadTabAtIndex:(NSUInteger)index{
    [self reloadTabs];
}


- (void)tap:(UITapGestureRecognizer *)tapGestureRecognizer{
    
    if(tapGestureRecognizer.state == UIGestureRecognizerStateRecognized)
    {        
        CGPoint point = [tapGestureRecognizer locationInView:self];
        CGFloat tabWidth = self.frame.size.width / [tabBarItemViews_ count];
        
        NSUInteger index = point.x / tabWidth;
        
        BOOL shouldSelect = YES;
        
        if([self.tabBarDelegate respondsToSelector:@selector(tabBar:shouldSelectTabAtIndex:)])
        {
            shouldSelect = [self.tabBarDelegate tabBar:self shouldSelectTabAtIndex:index];
        }
        
        if(shouldSelect)
        {
            [self setSelectedTabIndex:index];
        }
    }
    
}

@end
