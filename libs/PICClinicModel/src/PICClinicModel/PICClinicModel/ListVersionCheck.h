//
//  ListVersionCheck.h
//  PICClinic
//
//  Created by Wong Johnson on 2/26/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ListVersionCheck : NSManagedObject

@property (nonatomic, retain) NSString * list;
@property (nonatomic, retain) NSSet *listVersionData;
@end

@interface ListVersionCheck (CoreDataGeneratedAccessors)

- (void)addListVersionDataObject:(NSManagedObject *)value;
- (void)removeListVersionDataObject:(NSManagedObject *)value;
- (void)addListVersionData:(NSSet *)values;
- (void)removeListVersionData:(NSSet *)values;

@end
