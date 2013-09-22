//
//  PCNavigationController.m
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCNavigationController.h"
#import "PCTabBarController.h"

@interface PCNavigationController ()
@property (nonatomic, retain) UIView *dummyView;
@end

@implementation PCNavigationController

@synthesize navigationTitle = _navigationTitle;

- (UINavigationBar *)navigationBar
{
    UINavigationBar *navBar = [super navigationBar];
    if (!self.backgroundImageView) {
        if ([navBar.subviews count]) {
            [[navBar.subviews objectAtIndex:0] removeFromSuperview];
        }

        self.backgroundImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PICClinicModel.bundle/NavigationBarBackGroundAesth.png"]] autorelease];
        [navBar addSubview:_backgroundImageView];
    }
    [navBar addSubview:self.navigationTitle];
    [navBar sendSubviewToBack:_navigationTitle];
    [navBar sendSubviewToBack:_backgroundImageView];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        _backgroundImageView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 45.0f);
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _backgroundImageView.frame = CGRectMake(0.0f, 0.0f, 768.0f, 80.0f);
    }
    return navBar;
}

- (void)dealloc
{
    [_backgroundImageView release];
    [_navigationTitle release];
    [_dummyView release];
    [super dealloc];
}

#pragma mark Overrides

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[PCTabBarController class]]) {
        PCTabBarController *tabBarController = (PCTabBarController *)viewController;
        tabBarController.navController = self;
    }
    [super pushViewController:viewController animated:animated];
}

- (UILabel *)navigationTitle {
    if (!_navigationTitle) {
        _navigationTitle = [[UILabel alloc] init];
        _navigationTitle.textAlignment = UITextAlignmentCenter;
        _navigationTitle.textColor = [UIColor whiteColor];
        _navigationTitle.backgroundColor = [UIColor clearColor];
        //_navigationTitle.backgroundColor = [UIColor redColor];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _navigationTitle.frame = CGRectMake(60, 10, 200, 25);
            [_navigationTitle setFont:[UIFont fontWithName:@"Helvetica" size:20.0f]];
            _navigationTitle.font = [UIFont boldSystemFontOfSize:20.0f];
        } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _navigationTitle.frame = CGRectMake(140, 18, 480, 45);
            [_navigationTitle setFont:[UIFont fontWithName:@"Helvetica" size:35.0f]];
            _navigationTitle.font = [UIFont boldSystemFontOfSize:35.0f];
        }
    }
    return _navigationTitle;
}

#pragma mark UINavigationBarDelegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    if (!_dummyView) {
        _dummyView = [[UIView alloc] init];
    }
    item.titleView = _dummyView;
    _navigationTitle.text = item.title;
    return TRUE;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    _navigationTitle.text = [[navigationBar.items objectAtIndex:navigationBar.items.count - 2] title];
    return TRUE;
}

@end
