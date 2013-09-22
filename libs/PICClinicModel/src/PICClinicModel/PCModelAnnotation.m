//
//  PCModelAnnotation.m
//  PICClinicModel
//
//  Created by Wong Johnson on 3/27/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCModelAnnotation.h"

@implementation PCModelAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andannotationTitle:(NSString *)theAnnotationTitle
{
    if ((self = [super init])) {
        _coordinate = coordinate;
        self.annotationTitle = theAnnotationTitle;
    }
    return (self);
}

- (void)dealloc
{
    [_annotationTitle release];
    [super dealloc];
}

- (NSString *)title {
    return self.annotationTitle;
}

- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

@end
