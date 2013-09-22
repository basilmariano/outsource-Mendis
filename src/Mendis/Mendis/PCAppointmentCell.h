//
//  PCAppointmentCell.h
//  PICClinic
//
//  Created by Panfilo Mariano Jr. on 5/8/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCAppointmentCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *clientName;
@property (nonatomic, assign) IBOutlet UILabel *doctorName;
@property (nonatomic, assign) IBOutlet UILabel *scheduleDate;
@property (nonatomic, assign) IBOutlet UILabel *scheduleTime;

@end
