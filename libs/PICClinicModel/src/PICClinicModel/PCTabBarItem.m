//
//  PCTabBarItem.m
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCTabBarItem.h"

@implementation PCTabBarItem
- (void)dealloc
{
    [_tabButton release];
    [super dealloc];
}

+ (PCTabBarItem *)tabBarItemWithButton:(UIButton *)tabButton
{
    PCTabBarItem *item = [[PCTabBarItem alloc] init];
    item.tabButton = tabButton;
    return [item autorelease];
}

@end
