//
//  PCTexTFieldCell.h
//  PICClinicModel
//
//  Created by Panfilo Mariano Jr. on 5/22/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCTextFieldCell;

@protocol PCTextFieldCellDelegate <NSObject>

@optional
- (void)textFieldFinishedTyping;
- (void)textFieldWillStartTyping:(NSUInteger) cellIndex andTextfield:(UITextField *)textField;

@end

@interface PCTexTFieldCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UITextField *textField;
@property (nonatomic) int textFieldRange;
@property (nonatomic, assign) UIView *viewParam;
@property (nonatomic) NSUInteger index;
@property (nonatomic, assign) IBOutlet UIButton *buttonDone;
@property (nonatomic, assign) id<PCTextFieldCellDelegate> delegate;

@end
