//
//  PCLocalNotification.h
//  PICClinicModel
//
//  Created by Panfilo Mariano Jr. on 5/10/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Appointment.h"

@interface PCLocalNotification : NSObject

+(PCLocalNotification *)sharedInstance;
- (void) handleReceivedNotification:(UILocalNotification*) thisNotification;
- (void)scheduleNotificationWithFireDate: (NSDate *)fireDate andMedicine:(Appointment *)appointment;
- (void)scheduleNotificationWithFireDate: (NSDate *)fireDate andMedicine:(Appointment *)appointment andAlertMessage: (NSString *)message;
- (void)cancelNotificationWithAppointment: (Appointment *)medicine andFireDate:(NSDate *)fireTime;
- (void)deleteNotificationWithAppointment:(Appointment *)appointment fromNotification:(UILocalNotification *)notification;
//- (void)deleteNotificationWithMedicine:(Medicine *)medicine fromNotification:(UILocalNotification *)notification;
//- (void)cancelNotificationWithMedicine: (Medicine *)medicine andFireDate:(NSDate *)fireTime;
//- (void)cancelNotificationWithMedicine: (Medicine *)medicine andWithMedicineDayType: (NSUInteger)dayType;
- (void)showReminder:(NSString *)reminder;
//- (void)clearNotification;
//- (BOOL)isNotificationExistWithMedicine: (Medicine *)medicine andFireTime:(NSDate *)fireTime;


@end
