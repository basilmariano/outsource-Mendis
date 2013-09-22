//
//  ImageData.h
//  PICClinic
//
//  Created by Wong Johnson on 2/11/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ImageSliderData;

@interface ImageData : NSManagedObject

@property (nonatomic, retain) NSNumber *articleId;
@property (nonatomic, retain) NSNumber *imageId;
@property (nonatomic, retain) NSNumber *imageSequenceId;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) ImageSliderData *imageSliderData;

@end
