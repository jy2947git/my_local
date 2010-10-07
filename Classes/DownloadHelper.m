//
//  DownloadHelper.m
//  mylocal
//
//  Created by You, Jerry on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DownloadHelper.h"
// This framework was imported so we could use the kCFURLErrorNotConnectedToInternet error code.
#import <CFNetwork/CFNetwork.h>



@implementation DownloadHelper
@synthesize delegate, userInfo, url, connection, downloadedData, activeDownload;


- (id)initWithUserInfo:(NSDictionary*)ui Url:(NSString*)encodedUrlString delegate:(id)del{
	self=[self init];
	NSDictionary *d = [[NSDictionary alloc] initWithDictionary:ui];
	self.userInfo = d;
	[d release];
	self.url=encodedUrlString;
	self.delegate=del;
	return self;
}

// -------------------------------------------------------------------------------
//	dealloc
// -------------------------------------------------------------------------------
- (void)dealloc
{
	[userInfo release];
	[url release];
    [connection release];
    [downloadedData release];
	[activeDownload release];
	[super dealloc];
}


- (void)startDownload
{
	DebugLog(@"download-helper starting ...%@", self.url);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:self.url]] delegate:self];
    self.connection = conn;
    [conn release];
}

- (void)cancelDownload
{
    [self.connection cancel];
    self.connection = nil;
    self.activeDownload = nil;
}

#pragma mark -
#pragma mark NSURLConnection delegate methods


// The following are delegate methods for NSURLConnection. Similar to callback functions, this is how
// the connection object,  which is working in the background, can asynchronously communicate back to
// its delegate on the thread from which it was started - in this case, the main thread.
//

// -------------------------------------------------------------------------------
//	connection:didReceiveResponse:response
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.activeDownload = [NSMutableData data];    // start off with new data
}

// -------------------------------------------------------------------------------
//	connection:didReceiveData:data
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [activeDownload appendData:data];  // append incoming data
}

// -------------------------------------------------------------------------------
//	connection:didFailWithError:error
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	DebugLog(@"DownloadHelper failed!");
	activeDownload=nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.connection = nil;   // release our connection
	//call the delegate to notify the error
	[delegate downloadFinishedWithError:error userInfo:[userInfo copy]];
}

// -------------------------------------------------------------------------------
//	connectionDidFinishLoading:connection
// -------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	DebugLog(@"DownloadHelper is about to finish!");
    self.connection = nil;   // release our connection
    self.downloadedData = [NSData dataWithData:activeDownload];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
	[delegate downloadFinishedWithData:self.downloadedData userInfo:[userInfo copy]];
}

@end
