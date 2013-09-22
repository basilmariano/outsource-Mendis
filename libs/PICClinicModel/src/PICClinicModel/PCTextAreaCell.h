//
//  PCTextAreaCell.h
//  PICClinicModel
//
//  Created by Panfilo Mariano Jr. on 5/22/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCTextAreaCell;

@protocol PCTextAreaCellDelegate <NSObject>

@optional
- (void)textViewFinishedTyping;
- (void)textViewwillStartTyping:(NSUInteger) cellIndex andTextfield:(UITextView *)textView;

@end

@interface PCTextAreaCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic) int textFieldRange;
@property (nonatomic, assign) UIView *viewParam;
@property (nonatomic) NSUInteger index;
@property (nonatomic, retain) NSString *placeHolder;
@property (nonatomic, assign) id<PCTextAreaCellDelegate> delegate;

@end
