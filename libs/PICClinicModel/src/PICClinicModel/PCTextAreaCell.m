//
//  PCTextAreaCell.m
//  PICClinicModel
//
//  Created by Panfilo Mariano Jr. on 5/22/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCTextAreaCell.h"
#import "PCModelFormViewController.h"

@implementation PCTextAreaCell

CGFloat TA_animatedDistance;
CGFloat TA_KEYBOARD_ANIMATION_DURATION = 0.3;
CGFloat TA_MINIMUM_SCROLL_FRACTION = 0.2;
CGFloat TA_MAXIMUM_SCROLL_FRACTION = 0.8;
CGFloat TA_PORTRAIT_KEYBOARD_HEIGHT = 140;
CGFloat TA_LANDSCAPE_KEYBOARD_HEIGHT = 162;

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

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.viewParam.frame = CGRectMake(0, 0, self.viewParam.bounds.size.width, self.viewParam.bounds.size.height);
    
    [PCModelFormViewController orderViewController].value = textView.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewFinishedTyping)]) {
        [self.delegate performSelector:@selector(textViewFinishedTyping)];
        // [self.delegate performSelector:@selector(tableViewCell:withSomeEvent:) withObject:self withObject:nil]; //<-witch paramenter pased
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor darkGrayColor];
    CGRect textFieldRect = [self.viewParam.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect =[self.viewParam.window convertRect:self.viewParam.bounds fromView:self.viewParam];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y
    - TA_MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (TA_MAXIMUM_SCROLL_FRACTION - TA_MINIMUM_SCROLL_FRACTION)
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
        TA_animatedDistance = floor(TA_PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        TA_animatedDistance = floor(TA_LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.viewParam.frame;
    viewFrame.origin.y -= TA_animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:TA_KEYBOARD_ANIMATION_DURATION];
    
    [self.viewParam setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewwillStartTyping:andTextfield:)]) {
        
        [self.delegate performSelector:@selector(textViewwillStartTyping:andTextfield:) withObject:self.index withObject:self.textView];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) { //<- Should return in UItextFieldDelegate
        CGRect viewFrame = self.viewParam.frame;
        viewFrame.origin.y += TA_animatedDistance;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:TA_KEYBOARD_ANIMATION_DURATION];
        
        [self.viewParam setFrame:viewFrame];
        
        [UIView commitAnimations];
        [textView resignFirstResponder];
        
        return YES;
    }
    
  
    if([self textFieldRange] >= textView.text.length)
        return  YES;
    else {
        if([text isEqualToString:@""])
            return  YES;
        
        return NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{

}

- (void)textViewDidChangeSelection:(UITextView *)textView
{

}

- (void) dealloc
{
    [_placeHolder release];
    [_textView release];
    [super dealloc];
}

@end
