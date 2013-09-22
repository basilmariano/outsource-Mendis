//
//  ListItemsData.h
//  PICClinic
//
//  Created by Wong Johnson on 3/14/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListId;

@interface ListItemsData : NSManagedObject

@property (nonatomic, retain) NSNumber * action_id;
@property (nonatomic, retain) NSNumber * action_type;
@property (nonatomic, retain) NSNumber * list_id;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSNumber * item_id;
@property (nonatomic, retain) NSNumber * sequence_id;
@property (nonatomic, retain) NSString * item_name;
@property (nonatomic, retain) NSString * item_desc;
@property (nonatomic, retain) NSString * publish_date;
@property (nonatomic, retain) ListId *listId;

@end
