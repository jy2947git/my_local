//
//  DownloadOperation.m
//  mylocal
//
//  Created by You, Jerry on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DownloadOperation.h"


@implementation DownloadOperation
@synthesize downloadHelper, userInfo, urlString, delegate;

- (id)initWithUserInfo:(NSDictionary*)ui url:(NSString*)url delegate:(id <DownloaderDelegate>)d{
	self=[super init];
	if (self!=nil) {
		self.userInfo=ui;
		self.urlString=url;
		self.delegate=d;
	}
	return self;
}

- (void)dealloc{
	[downloadHelper release];
	[userInfo release];
	[urlString release];
	[super dealloc];
}

- (void)main{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	DebugLog(@"start background thread to query: %@", urlString);
	DownloadHelper *helper = [[DownloadHelper alloc] initWithUserInfo:userInfo Url:urlString delegate:self];
	self.downloadHelper=helper;
	[helper startDownload];
	[helper release];
	//wait until download helper finish
	
	[pool release];
}

- (void)downloadFinishedWithData:(NSData*)data userInfo:(NSDictionary*)userInfo{
	//pass on
	DebugLog(@"success!!");
	[delegate downloadFinishedWithData:data userInfo:self.userInfo];
}
- (void)downloadFinishedWithError:(NSError*)error userInfo:(NSDictionary*)userInfo{
	//pass on
	DebugLog(@"error!!");
	[delegate downloadFinishedWithError:error userInfo:self.userInfo];
}


@end
