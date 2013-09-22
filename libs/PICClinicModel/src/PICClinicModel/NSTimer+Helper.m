//
//  NSTimer+Helper.m
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "NSTimer+Helper.h"

@interface NSTimerReceiver : NSObject

@property (nonatomic, retain) id valueOrTarget;
@property (nonatomic) SEL selector;
@property (nonatomic, retain) id userInfo;

- (void)action;

@end

@implementation NSTimerReceiver

- (void)dealloc
{
    [_valueOrTarget release];
    [_userInfo release];
    [super dealloc];
}

- (void)action
{
    id target = _valueOrTarget;
    if ([target isKindOfClass:[NSValue class]]) {
        target = [_valueOrTarget nonretainedObjectValue];
    }
    if ([target respondsToSelector:_selector]) {
        [target performSelector:_selector withObject:_userInfo];
    }
}

@end

@implementation NSTimer(Helper)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti valueOrTarget:(id)valueOrTarget selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)yesOrNo
{
    NSTimerReceiver *receiver = [[NSTimerReceiver alloc] init];
    receiver.valueOrTarget = valueOrTarget;
    receiver.selector = selector;
    receiver.userInfo = userInfo;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:ti target:receiver selector:@selector(action) userInfo:userInfo repeats:yesOrNo];
    [receiver release];
    return timer;
}

@end
