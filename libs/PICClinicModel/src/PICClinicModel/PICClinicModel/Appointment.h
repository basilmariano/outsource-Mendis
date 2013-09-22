//
//  Appointment.h
//  PICClinicModel
//
//  Created by Panfilo Mariano Jr. on 5/10/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Appointment : NSManagedObject

@property (nonatomic, retain) NSNumber * appointmentDate;
@property (nonatomic, retain) NSNumber * appointmentTime;
@property (nonatomic, retain) NSString * clientName;
@property (nonatomic, retain) NSString * doctorName;
@property (nonatomic, retain) NSNumber * fireDate;
@property (nonatomic, retain) NSString * reminderAlert;
@property (nonatomic, retain) NSString * mobileNumber;
@property (nonatomic, retain) NSString * appointmentType;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * weight;
@property (nonatomic, retain) NSString * waist;

+ (Appointment *)appointment;
+ (NSArray *)appointmentList;
+ (NSArray *) appointmentListFromDate: (NSDate *)startDate to: (NSDate *)endDate;
+ (NSArray *) appointmentListFromDate: (NSDate *)date;

@end
