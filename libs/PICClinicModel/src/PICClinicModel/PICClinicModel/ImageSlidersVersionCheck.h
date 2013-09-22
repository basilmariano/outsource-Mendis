//
//  ImageSlidersVersionCheck.h
//  PICClinic
//
//  Created by Wong Johnson on 2/26/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ImageSlidersVersionCheck : NSManagedObject

@property (nonatomic, retain) NSString * imageSliders;
@property (nonatomic, retain) NSSet *imageSlidersVersionData;
@end

@interface ImageSlidersVersionCheck (CoreDataGeneratedAccessors)

- (void)addImageSlidersVersionDataObject:(NSManagedObject *)value;
- (void)removeImageSlidersVersionDataObject:(NSManagedObject *)value;
- (void)addImageSlidersVersionData:(NSSet *)values;
- (void)removeImageSlidersVersionData:(NSSet *)values;

@end
