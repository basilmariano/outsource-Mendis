//
//  LSMainCell.h
//  PICClinicModel
//
//  Created by Wong Johnson on 3/21/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSMainCell : UITableViewCell
@property (nonatomic, assign) IBOutlet UILabel *diseaseLabel;
@property (nonatomic, assign) IBOutlet UIImageView *arrowImage;
@property (nonatomic, assign) NSString *companyId;

@end
