//
//  ImageSlidersVersionData.h
//  PICClinic
//
//  Created by Wong Johnson on 2/26/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ImageSlidersVersionCheck;

@interface ImageSlidersVersionData : NSManagedObject

@property (nonatomic, retain) NSNumber * imageSliderId;
@property (nonatomic, retain) NSNumber * imageSliderVersion;
@property (nonatomic, retain) ImageSlidersVersionCheck *imageSliderVersionCheck;

@end
