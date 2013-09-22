//
//  ListIdNameVersionData.h
//  PICClinic
//
//  Created by Wong Johnson on 3/14/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListId;

@interface ListIdNameVersionData : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * list_id;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) ListId *listId;

@end
