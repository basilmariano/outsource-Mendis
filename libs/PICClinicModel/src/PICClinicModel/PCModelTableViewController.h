//
//  PCSecondTabViewController.h
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCModelTableViewController : UIViewController

- (id)initWithGroupListId:(NSString *)groupListIdString andGroupListTitle:(NSString *)groupListTitle andCompanyId:(NSString *)companyId andHidesBackButtonFirst:(BOOL)hidesBackButton;

- (id)initWithGroupListId:(NSString *)groupListIdString andGroupListTitle:(NSString *)groupListTitle andCompanyId:(NSString *)companyId andChangeNavigationBackground:(BOOL)changeNavigationBackground;

- (id)initWithGroupListId:(NSString *)groupListIdString andGroupListTitle:(NSString *)groupListTitle andCompanyId:(NSString *)companyId;

- (id)initForProductsWithGroupListId:(NSString *)groupListIdString andGroupListTitle:(NSString *)groupListTitle andCompanyId:(NSString *)companyId;

@end
