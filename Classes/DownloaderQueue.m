//
//  DownloaderQueue.m
//  mylocal
//
//  Created by You, Jerry on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DownloaderQueue.h"
#import "UrlDownloaderOperation.h"

@implementation DownloaderQueue
@synthesize queue;

- (id)init{
	self=[super init];
	if (self!=nil) {
		NSOperationQueue *q = [[NSOperationQueue alloc] init];
		self.queue=q;
		[q release];
	}
	return self;
}
- (void)enqueue:(UrlDownloaderOperation*)op{
	[queue addOperation:op];
}
- (void)dealloc{
	[queue release];
	[super dealloc];
}
@end
