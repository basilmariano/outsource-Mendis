//
//  WishListItem.m
//  PICClinicModel
//
//  Created by Jerry on 8/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "WishListItem.h"
#import "ManageObjectModel.h"


@implementation WishListItem

@dynamic appointmentDate;
@dynamic appointmentTime;
@dynamic clientName;
@dynamic doctorName;
@dynamic fireDate;
@dynamic reminderAlert;
@dynamic mobileNumber;
@dynamic appointmentType;
@dynamic notes;
@dynamic weight;
@dynamic waist;

+ (WishListItem *)wishListItems
{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Appointment" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    WishListItem *newWishListItem = [[[WishListItem alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]] autorelease];
    return newWishListItem;
}

+ (NSArray *) wishList
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WishList" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [[[PCModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return  fetchedObjects;
}

+ (NSArray *) appointmentListFromDate: (NSDate *)startDate to: (NSDate *)endDate
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WishList" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSNumber *dateStartInt =[NSNumber numberWithDouble: [startDate timeIntervalSince1970]];
    NSNumber *dateEndInt = [NSNumber numberWithDouble: [endDate timeIntervalSince1970]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"appointmentDate" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSPredicate *betweenPredicate = [NSPredicate predicateWithFormat:@"( ( %@ <= appointmentDate ) && ( appointmentDate <= %@) )",dateStartInt,dateEndInt];
    //[NSPredicate predicateWithFormat: @"appointmentDate BETWEEN %@", @[dateStartInt, dateEndInt]];
    [fetchRequest setPredicate:betweenPredicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[[PCModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return  fetchedObjects;
}

+ (NSArray *) appointmentListFromDate: (NSDate *)date
{
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WishList" inManagedObjectContext:[[PCModelManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSNumber *dateInt =[NSNumber numberWithDouble: [date timeIntervalSince1970]];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"appointmentDate" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSPredicate *betweenPredicate = [NSPredicate predicateWithFormat:@"( ( %@ == appointmentDate ) )",dateInt];
    //[NSPredicate predicateWithFormat: @"appointmentDate BETWEEN %@", @[dateStartInt, dateEndInt]];
    [fetchRequest setPredicate:betweenPredicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[[PCModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return  fetchedObjects;
}




@end
