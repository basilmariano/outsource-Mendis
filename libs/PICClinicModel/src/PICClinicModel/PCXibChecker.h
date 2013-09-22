//
//  PCXibChecker.h
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

extern BOOL PCIsPhone5;
NSString *PCNameForDevice(NSString *name);

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
