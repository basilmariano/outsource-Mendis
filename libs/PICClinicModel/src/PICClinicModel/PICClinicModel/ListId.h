//
//  ListId.h
//  PICClinic
//
//  Created by Wong Johnson on 3/14/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ListId : NSManagedObject

@property (nonatomic, retain) NSNumber * list_id;
@property (nonatomic, retain) NSSet *listIdNameVersionData;
@property (nonatomic, retain) NSSet *listItemsData;
@end

@interface ListId (CoreDataGeneratedAccessors)

- (void)addListIdNameVersionDataObject:(NSManagedObject *)value;
- (void)removeListIdNameVersionDataObject:(NSManagedObject *)value;
- (void)addListIdNameVersionData:(NSSet *)values;
- (void)removeListIdNameVersionData:(NSSet *)values;

- (void)addListItemsDataObject:(NSManagedObject *)value;
- (void)removeListItemsDataObject:(NSManagedObject *)value;
- (void)addListItemsData:(NSSet *)values;
- (void)removeListItemsData:(NSSet *)values;

@end
