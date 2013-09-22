//
//  LSWebViewController.h
//  LSAestheticClinic
//
//  Created by Wong Johnson on 3/19/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCModelWebViewController : UIViewController

- (id)initWithArticleId:(NSString *)articleId andArticleTitle:(NSString *)articleTitle andCompanyId:(NSString*)companyId andBackButtonHiddenFirst:(BOOL)buttonHiddenFirst;
- (id)initWithShareButtonAndArticleId:(NSString *)articleId andArticleTitle:(NSString *)articleTitle andCompanyId:(NSString*)companyId;
- (id)initWithUrlString:(NSString *)urlString andCompanyId:(NSString *)companyId andDontRequest:(BOOL)dontRequest;
- (id)initWithArticleId:(NSString *)articleId andArticleTitle:(NSString *)articleTitle andCompanyId:(NSString *)companyId andChangeNavigationBackground:(BOOL)changeNavigationBackground;
- (id)initWithArticleIdForWishList:(NSString *)articleId andArticleTitle:(NSString *)articleTitle andCompanyId:(NSString *)companyId;

@end
