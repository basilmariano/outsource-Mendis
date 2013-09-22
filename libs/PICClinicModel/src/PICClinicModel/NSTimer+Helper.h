//
//  NSTimer+Helper.h
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer(Helper)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti valueOrTarget:(id)valueOrTarget selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

@end
