//
//  PCRequestHandler.h
//  PICClinic
//
//  Created by Wong Johnson on 2/9/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCRequestHandler : NSObject

DECLARE_SINGLETON(PCRequestHandler);

+ (NSString *)documentPath;
+ (NSArray *)fetchRequestArticleVersionData;
+ (NSArray *)fetchRequestArticleData;
+ (NSArray *)fetchRequestImageSliderVersionData;
+ (NSArray *)fetchRequestListVersionData;
+ (NSArray *)fetchRequestImageSliderData;
+ (NSArray *)fetchRequestListData;
+ (NSArray *)fetchRequestListIdNameVersionData;
+ (NSArray *)fetchRequestListItemsData;

@property (nonatomic, retain)NSString *companyId;

- (void)requestVersionCheck:(NSString *)companyId;
- (void)requestImageSlider:(NSString *)imageSliderId andCompanyId:(NSString *)companyId;
- (void)requestDownloadArticle:(NSString *)articleIdString andCompanyId:(NSString *)companyId;
- (void)requestArticle:(NSString *)articleIdString andCompanyId:(NSString *)companyId;
- (void)requestGroupList:(NSString *)groupListId andCompanyId:(NSString *)companyId;
- (void)requestFormWithCompanyId :(NSString *) companyId andFormId :(NSString *) formId;

@end
