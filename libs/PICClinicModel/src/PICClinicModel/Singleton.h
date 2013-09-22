//
//  Singleton.h
//  PICClinic
//
//  Created by Wong Johnson on 2/21/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#define DECLARE_SINGLETON(_name_) \
+ (_name_ *)sharedInstance; \
+ (void)destroyInstance

#define DEFINE_SINGLETON(_name_) \
static _name_* g##_name_##Instance = nil; \
+ (_name_ * )sharedInstance { \
@synchronized([_name_ class]) { \
if (!g##_name_##Instance) \
[[self alloc] init]; \
return g##_name_##Instance; \
} \
return nil; \
} \
+ (id)alloc { \
@synchronized([_name_ class]) { \
NSAssert(g##_name_##Instance == nil, @"Attempted to allocate a second instance of a singleton."); \
g##_name_##Instance = [super alloc]; \
return g##_name_##Instance; \
} \
return nil; \
} \
+ (void)destroyInstance { \
@synchronized([_name_ class]) { \
if (g##_name_##Instance) { \
[g##_name_##Instance release]; \
g##_name_##Instance = nil; \
} \
} \
}
