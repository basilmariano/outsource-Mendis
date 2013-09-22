//
//  PCTabBarItem.h
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCTabBarItem : UITabBarItem

@property (nonatomic, retain) UIButton *tabButton;
+ (PCTabBarItem *)tabBarItemWithButton:(UIButton *)tabButton;

@end
