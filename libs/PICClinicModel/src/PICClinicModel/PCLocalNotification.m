//
//  PCLocalNotification.m
//  PICClinicModel
//
//  Created by Panfilo Mariano Jr. on 5/10/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCLocalNotification.h"

#import "PCLocalNotification.h"

@implementation PCLocalNotification

static PCLocalNotification *_instance;

+(PCLocalNotification *)sharedInstance {
    if(_instance == nil) {
        _instance = [[PCLocalNotification alloc] init];
    }
    return  _instance;
}

- (void) dealloc
{
    [super dealloc];
}

- (void)scheduleNotificationWithFireDate: (NSDate *)fireDate andMedicine:(Appointment *)appointment andAlertMessage: (NSString *)message {
    Class cls = NSClassFromString(@"UILocalNotification");
	if (cls != nil) {
        
        NSArray *notificationList = [UIApplication sharedApplication].scheduledLocalNotifications;
        
        for(UILocalNotification *localNotif in notificationList) {
            if([localNotif.fireDate isEqualToDate:fireDate]) {
                NSManagedObject *object = appointment;
                NSString *strPK         = [[[object objectID] URIRepresentation] absoluteString];
                NSString *tempPK        = strPK;
                NSDictionary *dict      = localNotif.userInfo;
                NSMutableArray *tempPkHolderList = [[[NSMutableArray alloc] init]autorelease];
                NSArray *appointmentPKList      = (NSArray *) [dict objectForKey:@"Appointment"];
                
                NSString *appointment_PK  = nil;
                for(NSString *primaryKey in appointmentPKList) {
                    if([primaryKey isEqualToString:tempPK]) {
                        /*medicine_PK = primaryKey;
                         [tempPkHolderList addObject:primaryKey];*/
                        return;
                    } else {
                        [tempPkHolderList addObject:primaryKey];
                    }
                }
                
                if(!appointment_PK)
                    [tempPkHolderList addObject:tempPK];
                
                NSString *alertBody = (NSString *) [dict objectForKey:@"Alert"];
                alertBody = message;
                NSArray *finalPKList = [NSArray arrayWithArray:tempPkHolderList];
                
                NSDictionary *userInfoDictObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                    finalPKList, @"Appointment",
                                                    alertBody,@"Alert",
                                                    nil];
                
                [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
                
                UILocalNotification *notif = [[cls alloc] init];
                notif.fireDate = fireDate;
                notif.timeZone = [NSTimeZone defaultTimeZone];
                
                notif.alertBody = alertBody;
                notif.alertAction = @"Show me";
                notif.soundName = UILocalNotificationDefaultSoundName;
                notif.applicationIconBadgeNumber = 1;
                notif.repeatInterval = 0;//<-date
                notif.userInfo = userInfoDictObject;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notif];
                [notif release];
                
                
                
                return;
            }
        }
        
		UILocalNotification *notif = [[cls alloc] init];
		notif.fireDate = fireDate;
		notif.timeZone = [NSTimeZone defaultTimeZone];
		
        
		notif.alertBody = message;
		notif.alertAction = @"Show me";
		notif.soundName = UILocalNotificationDefaultSoundName;
		notif.applicationIconBadgeNumber = 1;
		notif.repeatInterval = 0;
        
        NSManagedObject *object = appointment;
        NSString *strPK = [[[object objectID] URIRepresentation] absoluteString];
        
        NSMutableDictionary *dictObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [NSArray arrayWithObject:strPK], @"Appointment",
                                           notif.alertBody, @"Alert",
                                           nil];
		notif.userInfo = dictObject;
		
		[[UIApplication sharedApplication] scheduleLocalNotification:notif];
		[notif release];
	}
    
}


- (void)scheduleNotificationWithFireDate: (NSDate *)fireDate andMedicine:(Appointment *)appointment {
	
    Class cls = NSClassFromString(@"UILocalNotification");
	if (cls != nil) {
        
        NSArray *notificationList = [UIApplication sharedApplication].scheduledLocalNotifications;
        
        for(UILocalNotification *localNotif in notificationList) {
            if([localNotif.fireDate isEqualToDate:fireDate]) {
                NSManagedObject *object = appointment;
                NSString *strPK         = [[[object objectID] URIRepresentation] absoluteString];
                NSString *tempPK        = strPK;
                NSDictionary *dict      = localNotif.userInfo;
                NSMutableArray *tempPkHolderList = [[[NSMutableArray alloc] init]autorelease];
                NSArray *appointmentPKList      = (NSArray *) [dict objectForKey:@"Appointment"];
                
                NSString *appointment_PK  = nil;
                for(NSString *primaryKey in appointmentPKList) {
                    if([primaryKey isEqualToString:tempPK]) {
                        /*medicine_PK = primaryKey;
                         [tempPkHolderList addObject:primaryKey];*/
                        return;
                    } else {
                        [tempPkHolderList addObject:primaryKey];
                    }
                }
                
                if(!appointment_PK)
                    [tempPkHolderList addObject:tempPK];
                
                NSString *alertBody = (NSString *) [dict objectForKey:@"Alert"];
                NSString *companyId = [PCRequestHandler sharedInstance].companyId;
                if ([companyId isEqualToString:@"15"]) {
                    alertBody = @"Visit WAYAN For Your Massage";
                } else {
                    [alertBody stringByAppendingFormat:@" and %@",appointment.doctorName];//<- update the body
                }
                
                NSArray *finalPKList = [NSArray arrayWithArray:tempPkHolderList];
                
                NSDictionary *userInfoDictObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                    finalPKList, @"Appointment",
                                                    alertBody,@"Alert",
                                                    nil];
                
                [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
                
                UILocalNotification *notif = [[cls alloc] init];
                notif.fireDate = fireDate;
                notif.timeZone = [NSTimeZone defaultTimeZone];
                
                notif.alertBody = alertBody;
                notif.alertAction = @"Show me";
                notif.soundName = UILocalNotificationDefaultSoundName;
                notif.applicationIconBadgeNumber = 1;
                notif.repeatInterval = 0;//<-date
                notif.userInfo = userInfoDictObject;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notif];
                [notif release];
                
                
                
                return;
            }
        }
        
		UILocalNotification *notif = [[cls alloc] init];
		notif.fireDate = fireDate;
		notif.timeZone = [NSTimeZone defaultTimeZone];
		
        NSString *companyId = [PCRequestHandler sharedInstance].companyId;
        if ([companyId isEqualToString:@"15"]) {
            notif.alertBody = @"Visit WAYAN For Your Massage";
        } else {
            notif.alertBody = [NSString stringWithFormat:@"Appointment with following Doctor/s: %@ ", appointment.doctorName];
        }
        
		notif.alertAction = @"Show me";
		notif.soundName = UILocalNotificationDefaultSoundName;
		notif.applicationIconBadgeNumber = 1;
		notif.repeatInterval = 0;
        
        NSManagedObject *object = appointment;
        NSString *strPK = [[[object objectID] URIRepresentation] absoluteString];
        
        NSMutableDictionary *dictObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [NSArray arrayWithObject:strPK], @"Appointment",
                                           notif.alertBody, @"Alert",
                                           nil];
		notif.userInfo = dictObject;
		
		[[UIApplication sharedApplication] scheduleLocalNotification:notif];
		[notif release];
	}
}

- (void)cancelNotificationWithAppointment: (Appointment *)appointment andFireDate:(NSDate *)fireDate
{
    NSArray *notificationList = [UIApplication sharedApplication].scheduledLocalNotifications;
    for(UILocalNotification *localNotif in notificationList) {
        
        if([localNotif.fireDate isEqualToDate:fireDate]) {
            NSDictionary *dict         = localNotif.userInfo;
            NSManagedObject *object    = appointment;
            NSString *appointmentPK    = [[[object objectID] URIRepresentation] absoluteString];
            NSArray *appointmentPKList = (NSArray *) [dict objectForKey:@"Appointment"];
            
            for(NSString *strPK in appointmentPKList) {
                if([strPK isEqualToString:appointmentPK]) {
                    [self deleteNotificationWithAppointment:appointment fromNotification:localNotif];//<-do recursion
                }
            }
        }
    }
}

- (void)deleteNotificationWithAppointment:(Appointment *)appointment fromNotification:(UILocalNotification *)notification
{
    if(notification) {
        NSString *alertBody = @"";
        NSDictionary *dict  = notification.userInfo;
        NSArray *medPKList  = (NSArray *) [dict objectForKey:@"Appointment"];
        NSMutableArray *tempPkHolderList = [[[NSMutableArray alloc] init]autorelease];
        
        if(medPKList.count > 1) {
            for(NSString *pk in medPKList) {
                NSManagedObject *object = appointment;
                NSString *medicinePK    = [[[object objectID] URIRepresentation] absoluteString];
                
                if(![medicinePK isEqualToString:pk]){
                    [tempPkHolderList addObject:pk];
                    
                    NSManagedObject *managedObject = [[[PCModelManager sharedManager] managedObjectContext] objectWithID:[[[PCModelManager sharedManager]persistentStoreCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:pk]]];
                    Appointment *app = (Appointment *) managedObject;
                    alertBody     = [alertBody stringByAppendingFormat:@"Appointment with following Doctor/s: %@, ",app.doctorName];//<- update the body
                }
            }
        } else{
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            return;
        }
        
        NSArray *finalPKList = [NSArray arrayWithArray:tempPkHolderList];
        NSDictionary *userInfoDictObject = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            finalPKList, @"Appointment",
                                            alertBody,@"Alert",
                                            nil];
        
        Class cls = NSClassFromString(@"UILocalNotification");
        
        UILocalNotification *notif = [[cls alloc] init];
        notif.fireDate = notification.fireDate;
        notif.timeZone = [NSTimeZone defaultTimeZone];
        
        notif.alertBody      = notification.alertBody;
        notif.alertAction    = @"Show me";
        notif.soundName      = UILocalNotificationDefaultSoundName;
        notif.applicationIconBadgeNumber = 1;
        notif.repeatInterval = notification.repeatInterval;
        notif.userInfo       = userInfoDictObject;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        [notif release];
        
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    } else {
        NSArray *notificationList = [UIApplication sharedApplication].scheduledLocalNotifications;
        for(UILocalNotification *localNotif in notificationList) {
            NSDictionary *dict      = localNotif.userInfo;
            NSManagedObject *object = appointment;
            NSString *medicinePK    = [[[object objectID] URIRepresentation] absoluteString];
            NSArray *medPKList      = (NSArray *) [dict objectForKey:@"Appointment"];
            
            for(NSString *strPK in medPKList) {
                if([strPK isEqualToString:medicinePK]) {
                    [self deleteNotificationWithAppointment:appointment fromNotification:localNotif];
                }
            }
        }
    }
}

- (void)showReminder:(NSString *)text {
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:text delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}
- (void) handleReceivedNotification:(UILocalNotification*) thisNotification
{
	//NSLog(@"Received: %@",[thisNotification description]);
    [self showReminder:thisNotification.alertBody];
}

@end

