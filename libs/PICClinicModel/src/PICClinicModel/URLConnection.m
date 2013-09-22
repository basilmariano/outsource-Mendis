//
//  URLConnection.m
//  PICClinic
//
//  Created by Wong Johnson on 2/7/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "URLConnection.h"

@implementation URLConnection

@synthesize receivedData = _receivedData;

- (void)dealloc {
    [_userInfo release];
    [super dealloc];
}

- (id)initWithRequest:(NSMutableURLRequest *)request target:(id)target finished:(SEL)finished failed:(SEL)failed
{
	[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
	self = [super initWithRequest:request delegate:self];
	if (self) {
		_target = target;
		_finished = finished;
		_failed = failed;
	}
	return (self);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	_receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[_target performSelector:_finished withObject:self];
	[_receivedData release];
	_receivedData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[_target performSelector:_failed withObject:self];
	[_receivedData release];
	_receivedData = nil;
}

@end
