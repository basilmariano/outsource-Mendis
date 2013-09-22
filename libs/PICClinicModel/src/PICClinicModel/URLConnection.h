//
//  URLConnection.h
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLConnection : NSURLConnection
{
	NSMutableData *_receivedData;
	id _target;
	SEL _finished;
	SEL _failed;
}

@property (nonatomic, readonly) NSData *receivedData;
@property (nonatomic, retain) id userInfo;

- (id)initWithRequest:(NSMutableURLRequest *)request target:(id)target finished:(SEL)finished failed:(SEL)failed;

@end
