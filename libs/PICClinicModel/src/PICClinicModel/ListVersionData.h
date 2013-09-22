//
//  ListVersionData.h
//  PICClinic
//
//  Created by Wong Johnson on 2/26/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListVersionCheck;

@interface ListVersionData : NSManagedObject

@property (nonatomic, retain) NSNumber * listId;
@property (nonatomic, retain) NSNumber * listVersion;
@property (nonatomic, retain) ListVersionCheck *listVersionCheck;

@end
