//
//  LSAnnotation.h
//  LSAestheticClinic
//
//  Created by Wong Johnson on 3/20/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LSAnnotation : NSObject<MKAnnotation> {
    
    CLLocationCoordinate2D _coordinate;
    
}
@property (nonatomic, retain) NSString *annotationTitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andannotationTitle:(NSString *)theAnnotationTitle;

@end