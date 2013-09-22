//
//  DentistCell.h
//  PICClinicModel
//
//  Created by Wong Johnson on 3/22/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DentistCell : UITableViewCell
@property (nonatomic, assign) IBOutlet PCAsyncImageView *asyncImageView;
@property (nonatomic, assign) IBOutlet UILabel *dentistName;
@property (nonatomic, assign) IBOutlet UILabel *dentistDesc;
@property (nonatomic, assign) IBOutlet UIImageView *arrow;

@end
