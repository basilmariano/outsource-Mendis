//
//  PCTabBarController.m
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCTabBarController.h"
#import "PCTabBarItem.h"
#import "PCNavigationController.h"
@interface PCTabBarController ()

@property (nonatomic, retain) UINavigationItem *navItem;

@end

@implementation PCTabBarController

- (id)initWithTabBarBackgroundImage:(UIImage *)backgroundImage
{
    if ((self = [super init])) {
        self.tabBarBackgroundImageView.image = backgroundImage;
    }
    return (self);
}

- (void)dealloc
{
    [_tabBarBackgroundImageView release];
    [_utilityViews release];
    [_navItem release];
    [super dealloc];
}

#pragma mark View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    CGRect frame = self.view.frame;
    frame.size.height += self.tabBar.frame.size.height;
    self.view.frame = frame;
    [[self.view.subviews objectAtIndex:0] setFrame:frame];
    self.tabBarBackgroundImageView = [[[UIImageView alloc] init] autorelease];
    [self.view addSubview:_tabBarBackgroundImageView];
    for (UIView *view in self.utilityViews) {
        [self.view addSubview:view];
    }
}

- (UINavigationItem *)navigationItem {
    if (!_navItem) {
        _navItem = [[UINavigationItem alloc] init];
    }
    return _navItem;
}

- (void)setNavController:(UINavigationController *)navController {
    _navController = navController;
    if (navController) {
        if (self.navController && [self.navController isKindOfClass:[PCNavigationController class]]) {
            PCNavigationController *navController = (PCNavigationController *)self.navController;
            navController.navigationTitle.text = self.selectedViewController.navigationItem.title;
        }
    }
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    [super setViewControllers:viewControllers];
    for (UIViewController *controller in self.viewControllers) {
        UITabBarItem *item = controller.tabBarItem;
        NSAssert([item isKindOfClass:[PCTabBarItem class]], @"must use PCTabBarItem for tabBarItem");
        PCTabBarItem *tabBarItem = (PCTabBarItem *)item;
        [tabBarItem.tabButton addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tabBarItem.tabButton];
    }
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    if (selectedIndex < self.viewControllers.count) {
        for (int i = 0; i < self.viewControllers.count; ++i) {
            UIViewController *controller = [self.viewControllers objectAtIndex:i];
            UITabBarItem *item = controller.tabBarItem;
            NSAssert([item isKindOfClass:[PCTabBarItem class]], @"must use PCTabBarItem for tabBarItem");
            PCTabBarItem *tabBarItem = (PCTabBarItem *)item;
            if (selectedIndex == i) {
                _navItem.title = controller.navigationItem.title;
                if (self.navController && [self.navController isKindOfClass:[PCNavigationController class]]) {
                    PCNavigationController *navController = (PCNavigationController *)self.navController;
                    navController.navigationTitle.text = controller.navigationItem.title;
                }
                tabBarItem.tabButton.selected = YES;
            } else {
                tabBarItem.tabButton.selected = NO;
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [self.delegate performSelector:@selector(tabBarController:didSelectViewController:) withObject:self withObject:[self.viewControllers objectAtIndex:selectedIndex]];
    }
}

- (void)setUtilityViews:(NSArray *)utilityViews
{
    if (_utilityViews) {
        for (UIView *view in _utilityViews) {
            [view removeFromSuperview];
        }
        [_utilityViews release];
        _utilityViews = nil;
    }
    if (utilityViews) {
        _utilityViews = [utilityViews retain];
        for (UIView *view in _utilityViews) {
            [self.view addSubview:view];
        }
    }
}

- (void)tabButtonClicked:(UIButton *)tabButton
{
    for (int i = 0; i < [self.viewControllers count]; ++i) {
        UIViewController *controller = [self.viewControllers objectAtIndex:i];
        UITabBarItem *item = controller.tabBarItem;
        NSAssert([item isKindOfClass:[PCTabBarItem class]], @"must use PCTabBarItem for tabBarItem");
        PCTabBarItem *tabBarItem = (PCTabBarItem *)item;
        if (tabButton == tabBarItem.tabButton) {
            tabBarItem.tabButton.selected = YES;
            self.selectedIndex = i;
        } else {
            tabBarItem.tabButton.selected = NO;
        }
    }
}

- (void)hideTabBar
{
    for (UIViewController *controller in self.viewControllers) {
        UITabBarItem *item = controller.tabBarItem;
        NSAssert([item isKindOfClass:[PCTabBarItem class]], @"must use PCTabBarItem for tabBarItem");
        PCTabBarItem *tabBarItem = (PCTabBarItem *)item;
        tabBarItem.tabButton.hidden = YES;
    }
    self.tabBarBackgroundImageView.hidden = YES;
    for (UIView *view in self.utilityViews) {
        view.hidden = YES;
    }
}

- (void)showTabBar
{
    for (UIViewController *controller in self.viewControllers) {
        UITabBarItem *item = controller.tabBarItem;
        NSAssert([item isKindOfClass:[PCTabBarItem class]], @"must use PCTabBarItem for tabBarItem");
        PCTabBarItem *tabBarItem = (PCTabBarItem *)item;
        tabBarItem.tabButton.hidden = NO;
    }
    self.tabBarBackgroundImageView.hidden = NO;
    for (UIView *view in self.utilityViews) {
        view.hidden = NO;
    }
}

@end
