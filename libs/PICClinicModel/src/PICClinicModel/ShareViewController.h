//
//  ShareViewController.h
//  PICClinicModel
//
//  Created by Sil on 6/14/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UITextView *txtAreaMessageContent;
@property (nonatomic) NSUInteger senderTag;
@property (nonatomic, retain) IBOutlet UIImageView *textAreaBGImage;

- (id)initWithPlaceHolder:(NSString *)placeHolder;

@end
