//
//  PCModelAnnotation.h
//  PICClinicModel
//
//  Created by Wong Johnson on 3/27/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PCModelAnnotation : NSObject<MKAnnotation> {
    
    CLLocationCoordinate2D _coordinate;
    
}
@property (nonatomic, retain) NSString *annotationTitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andannotationTitle:(NSString *)theAnnotationTitle;

@end
