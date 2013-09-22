//
//  PCCell.m
//  PICClinic
//
//  Created by Wong Johnson on 3/8/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCCell.h"

@implementation PCCell

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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
 
    self.dimmerView.frame = CGRectMake(0, 0, self.frame.size.width, self.asyncImageView.bounds.size.height);

    if (highlighted) {
        self.dimmerView.hidden = FALSE;
    } else {
        self.dimmerView.hidden = TRUE;
    }
}


@end
