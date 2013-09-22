//
//  PCTexTFieldCell.m
//  PICClinicModel
//
//  Created by Panfilo Mariano Jr. on 5/22/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCTexTFieldCell.h"
#import "PCModelFormViewController.h"

@implementation PCTexTFieldCell

CGFloat TF_animatedDistance;
CGFloat TF_KEYBOARD_ANIMATION_DURATION = 0.3;
CGFloat TF_MINIMUM_SCROLL_FRACTION = 0.2;
CGFloat TF_MAXIMUM_SCROLL_FRACTION = 0.8;
CGFloat TF_PORTRAIT_KEYBOARD_HEIGHT = 150;
CGFloat TF_LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  
    if([self textFieldRange] >= textField.text.length)
        return  YES;
    else {
        if([string isEqualToString:@""])
            return  YES;
        
        return NO;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    CGRect viewFrame = self.viewParam.frame;
    viewFrame.origin.y += TF_animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:TF_KEYBOARD_ANIMATION_DURATION];
    
    [self.viewParam setFrame:viewFrame];
    
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return  YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.viewParam.frame = CGRectMake(0, 0, self.viewParam.bounds.size.width, self.viewParam.bounds.size.height);
    
    [PCModelFormViewController orderViewController].value = textField.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldFinishedTyping)]) {
        [self.delegate performSelector:@selector(textFieldFinishedTyping)];
        // [self.delegate performSelector:@selector(tableViewCell:withSomeEvent:) withObject:self withObject:nil]; //<-witch paramenter pased
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.viewParam.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =[self.viewParam.window convertRect:self.viewParam.bounds fromView:self.viewParam];
    CGFloat midline = textFieldRect.origin.y + .5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y
    - TF_MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (TF_MAXIMUM_SCROLL_FRACTION - TF_MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        TF_animatedDistance = floor(TF_PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        TF_animatedDistance = floor(TF_LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.viewParam.frame;
    viewFrame.origin.y -= TF_animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:TF_KEYBOARD_ANIMATION_DURATION];
    
    [self.viewParam setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldWillStartTyping:andTextfield:)]){
        
        [self.delegate performSelector:@selector(textFieldWillStartTyping:andTextfield:) withObject:self.index withObject:self.textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

@end
