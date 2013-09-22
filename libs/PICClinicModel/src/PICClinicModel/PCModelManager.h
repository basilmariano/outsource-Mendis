//
//  PCModelAppDelegate.h
//  PICClinicModel
//
//  Created by Wong Johnson on 3/15/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCModelManager : NSObject

@property (readonly, retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) BOOL versionCheckFinished;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (PCModelManager *)sharedManager;

@end
