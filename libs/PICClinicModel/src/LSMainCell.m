//
//  LSMainCell.m
//  PICClinicModel
//
//  Created by Wong Johnson on 3/21/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "LSMainCell.h"

@implementation LSMainCell

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
    if([_companyId isEqualToString:@"10"]) {
        UIImageView *selBGView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AMC -Listview-bg-ss.png"]] autorelease];
        self.selectedBackgroundView = selBGView;
    }
}

@end
