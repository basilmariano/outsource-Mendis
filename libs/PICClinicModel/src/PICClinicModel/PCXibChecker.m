//
//  PCXibChecker.m
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "PCXibChecker.h"

BOOL PCIsPhone5 = NO;

NSString *PCNameForDevice(NSString *name)
{
    if (PCIsPhone5) {
        NSString *filename = [name stringByDeletingPathExtension];
        NSString *extension = [name pathExtension];
        NSString *dot = @"";
        if (extension && [extension length]) {
            dot = @".";
        }
        return [NSString stringWithFormat:@"%@-h568%@%@", filename, dot, extension];
    }
    return name;
}
