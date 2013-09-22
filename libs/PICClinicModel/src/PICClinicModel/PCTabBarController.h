//
//  PCTabBarController.h
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCTabBarController : UITabBarController

@property (nonatomic, assign) UINavigationController *navController;
@property (nonatomic, retain) UIImageView *tabBarBackgroundImageView;
@property (nonatomic, retain) NSArray *utilityViews;

- (id)initWithTabBarBackgroundImage:(UIImage *)backgroundImage;

- (void)hideTabBar;
- (void)showTabBar;

@end
