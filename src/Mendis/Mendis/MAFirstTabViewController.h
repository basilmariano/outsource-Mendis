//
//  MAFirstTabViewController.h
//  Mendis
//
//  Created by Wong Johnson on 6/27/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAFirstTabViewController : UIViewController

@property (nonatomic, retain) IBOutlet SMPageControl *pageControl;
@property (nonatomic, retain) IBOutlet SwipeView *swipeView;

- (IBAction)pageControlTapped;

- (id)initWithArticleId:(NSString *)articleId andImageSliderId:(NSString *)imageSliderId andCompanyId:(NSString *)companyId;

@end
