//
//  WishListItem.h
//  PICClinicModel
//
//  Created by Jerry on 8/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface WishListItem : NSManagedObject


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

+ (WishListItem *)wishListItems;
+ (NSArray *)wishList;
+ (NSArray *) appointmentListFromDate: (NSDate *)startDate to: (NSDate *)endDate;
+ (NSArray *) appointmentListFromDate: (NSDate *)date;


@end
