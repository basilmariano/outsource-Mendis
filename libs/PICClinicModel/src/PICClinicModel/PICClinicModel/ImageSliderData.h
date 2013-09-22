//
//  ImageSliderData.h
//  PICClinic
//
//  Created by Wong Johnson on 2/11/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ImageData;

@interface ImageSliderData : NSManagedObject

@property (nonatomic, retain) NSNumber * imageSliderId;
@property (nonatomic, retain) NSString * imageSliderName;
@property (nonatomic, retain) NSNumber * imageSliderVersion;
@property (nonatomic, retain) NSSet *imagesData;
@end

@interface ImageSliderData (CoreDataGeneratedAccessors)

- (void)addImagesDataObject:(ImageData *)value;
- (void)removeImagesDataObject:(ImageData *)value;
- (void)addImagesData:(NSSet *)values;
- (void)removeImagesData:(NSSet *)values;

@end
