//
//  PCTextField.m
//  PICClinic
//
//  Created by Wong Johnson on 3/6/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCTextField.h"

@implementation PCTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void) drawRect:(CGRect)rect
{
    
    UIImage  *imgClear = [UIImage imageNamed:@"Delete_icon~ipad.png"];
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [clearButton setImage:imgClear forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
    self.clearButtonMode = UITextFieldViewModeNever;
    [self setRightViewMode:UITextFieldViewModeWhileEditing];
    [self setRightView:clearButton];
    
    [clearButton release];
}

- (BOOL)becomeFirstResponder{
    BOOL ret = YES ;
    ret = [super becomeFirstResponder] ;
    if( ret && ![self.text isEqualToString:@""]){
        self.rightViewMode = UITextFieldViewModeAlways;
    }else{
        self.rightViewMode = UITextFieldViewModeNever;
    }
    
    return ret ;
}
- (BOOL)resignFirstResponder
{
    BOOL ret = YES ;
    ret = [super resignFirstResponder] ;
    if( ret )
        self.rightViewMode = UITextFieldViewModeNever;
    return ret ;
}
- (void) clearText:(id)sender
{
    self.text = @"";
    self.rightViewMode = UITextFieldViewModeNever;
}

@end
