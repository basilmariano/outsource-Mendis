//
//  PCListButton.m
//  PICClinic
//
//  Created by Wong Johnson on 3/12/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCListButton.h"

@implementation PCListButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [_listButton release];
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
