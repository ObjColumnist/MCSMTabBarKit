# MCSMTabBar

__This is work in progress__ to provide a custom Tab Bar (and Tab Bar Controller) for situations where the default Tab Bar Controller `UITabBarController` isn't appropriate.

Examples of where a custom Tab Bar might be useful are:

* To customize the Look and Feel
* Positioning of the Tab Bar
* *Illegal Behaviour*, such as having a Tab Bar Controller in a Navigation Controller


Currently `MCSMTabBar` doesn't support badges or drag an drop customization.

## MCSMTabBar

To use `MCSMTabBar` you simply need to initalize an instance and become its Data Source and more than likely its Delegate too:

	MCSMTabBar *tabBar = [[MCSMTabBar alloc] initWithStyle:MCSMTabBarStyleDefault];
	tabBar.tabBarDataSource = (id<MCSMTabBarDataSource>)self;
	tabBar.tabBarDelegate = (id<MCSMTabBarDelegate>)self;


If you want to customize the layout ot the Tab Bar you will want to subclass `MCSMTabBar` and set the style to `MCSMTabBarStyleCustom`

The Data Source only has 2 methods both of which are required:


	@protocol MCSMTabBarDataSource <NSObject>
	
	@required
	- (NSUInteger)numberOfTabsInTabBar:(MCSMTabBar *)tabBar;
	- (MCSMTabBarItemView *)tabBar:(MCSMTabBar *)tabBar tabBarItemViewForTabAtIndex:(NSUInteger)index;
	
	@end
	
The Delegate has two optional methods for managing selection:

	@protocol MCSMTabBarDelegate <NSObject>

	@optional
	- (BOOL)tabBar:(MCSMTabBar *)tabBar shouldSelectTabAtIndex:(NSUInteger)index;
	- (void)tabBar:(MCSMTabBar *)tabBar didSelectTabAtIndex:(NSUInteger)index;
	
	@end

## MCSMTabBarItemView


`MCSMTabBarItemView` works a lot like `UITableViewCell`, you simply create one with the relevant data and carry out any layout customization in `layoutSubviews`


	- (MCSMTabBarItemView *)tabBar:(MCSMTabBar *)tabBar tabBarItemViewForTabAtIndex:(NSUInteger)index{
	
		MCSMTabBarItemView *tabBarItemView = nil;
	
		tabBarItemView = [[[MCSMTabBarItemView alloc] initWithStyle:tabBar.style] autorelease];
		
		[tabBarItemView setTitle:title];
		[tabBarItemView setImage:image];
		[tabBarItemView setSelectedImage:selectedImage];
	
		return tabBarItemView;
	}

## MCSMTabBarController

`MCSMTabBarController` is designed to be a replacement for `UITabBarController`, it automatically creates a `MCSMTabBar` (if one isn't set) and supplies a `MCSMTabBarItemView` for every `UIViewController` in the Tab Bar.

You can either initalize one with a style:

	MCSMTabBarController *tabBarController = [[MCSMTabBarController alloc] initWithStyle:MCSMTabBarStyleDefault];


Or with a Tab Bar:

	MCSMTabBar *tabBar = [[MCSMTabBar alloc] initWithStyle:MCSMTabBarStyleDefault];
	MCSMTabBarController *tabBarController = [[MCSMTabBarController alloc] initWithTabBar:tabBar];

You can also set the Tab Bar's position:

	tabBarController.tabBarPosition = MCSMTabBarControllerTabBarPositionTop;
	
Then set the view controllers you want to be in the Tab Bar Controller:

	[tabBarController setViewControllers:viewControllers];

If you want to customize the `MCSMTabBarItemViews` in the Tab Bar, you can become the Tab Bar Controller's Data Source and Implement `tabBarController:tabBarItemViewForViewController:`

	@protocol MCSMTabBarControllerDataSource <NSObject>
	
	@optional
	- (MCSMTabBarItemView *)tabBarController:(MCSMTabBarController *)tabBarController tabBarItemViewForViewController:(UIViewController *)viewController;
	
	@end

Like `UITabBarController` `MCSMTabBarController` has numerous delegate methods to handle selection and to handle `UINavigationControllers` so `hidesBottomBarWhenPushed` can be supported:

	@protocol MCSMTabBarControllerDelegate <NSObject>
	
	@optional
		
	- (BOOL)tabBarController:(MCSMTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
	- (void)tabBarController:(MCSMTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
	
	
	- (BOOL)tabBarController:(MCSMTabBarController *)tabBarController shouldBecomeDelegateOfNavigationController:(UINavigationController *)navigationController;
	
	- (void)tabBarController:(MCSMTabBarController *)tabBarController navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
	- (void)tabBarController:(MCSMTabBarController *)tabBarController navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

	@end

 