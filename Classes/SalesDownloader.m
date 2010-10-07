//
//  SaleItemHelper.m
//  mylocal
//
//  Created by You, Jerry on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SalesDownLoader.h"
#import "GlobalHeader.h"
#import "CoreLocation/CLLocation.h"
#import "JSON.h"
#import "SaleForView.h"
#import "ImageInfo.h"

NSString *SaleItemsDownloadFinished = @"SaleItemsDownloadFinished";
NSString *SaleItemsDownloadError = @"SaleItemsDownloadError";

static SalesDownloader *sharedObject;
static BOOL running;
//private methods
@interface SalesDownloader ()
- (void)processBrowseResponse:(NSString*)replyString;

@end

@implementation SalesDownloader
@synthesize items, downloader,delegates, lastQueryLocation, currentLocation;

- (id)init{
	if (self=[super init]) {
		NSMutableArray *a = [[NSMutableArray alloc] init];
		self.items=a;
		[a release];
		DownloadHelper *d = [[DownloadHelper alloc] init];
		[d setDelegate:self];
		self.downloader=d;
		[d release];
		
		NSMutableArray *d2 = [[NSMutableArray alloc] init];
		self.delegates=d2;
		[d2 release];
		//
		running=NO;
		//start updating location
		[[MyCLController sharedInstance] registerListener:self];
		[[MyCLController sharedInstance] startUpdateLocation];
	}
	return self;
}

- (void)dealloc{
	[self.items release];
	[self.downloader release];
	//stop updating location
	[[MyCLController sharedInstance] deregisterListener:self];
	[[MyCLController sharedInstance] stopUpdateLocation];
	[delegates release];
	[lastQueryLocation release];
	[currentLocation release];
	[super dealloc];
}

+ (SalesDownloader*)sharedInstance{
	if (sharedObject==nil) {
		sharedObject = [[SalesDownloader alloc] init];
	}
	return sharedObject;
}
- (void)registerListener:(id)listener{
	if (![sharedObject.delegates containsObject:listener]) {
		[sharedObject.delegates addObject:listener];
	}
}
-(void)deregisterListener:(id)listener{
	[sharedObject.delegates removeObject:listener];
}

- (BOOL)isRunning{
	return running;
}

- (void)forceToRefreshSaleItems{
	[self dowloadSaleItemsFromLocation:self.lastQueryLocation];
}

-(void)dowloadSaleItemsFromLocation:(CLLocation *)location{
	if (running) {
		return;
	}
	running=YES;
	NSString *latitudeString = [NSString stringWithFormat:@"%.6f",location.coordinate.latitude];
	NSString *longitudeString = [NSString stringWithFormat:@"%.6f",location.coordinate.longitude];
	NSString *messageString = [NSString stringWithFormat:@"token=%@&command=browse&start=0&end=100&latitude=%@&longitude=%@",requestToken,latitudeString,longitudeString];
	DebugLog(@"request:%@", messageString);
    //NSString *encodedMessageString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)messageString, CFSTR(""), CFSTR(" %\"?=&+<>;:-"),  kCFStringEncodingUTF8);
	NSString *urlString = [NSString stringWithFormat:@"http://%@/yardsale?%@",serverHost, messageString];
	NSString *urlEncodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	//start the downloading
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"items",@"identifier",urlEncodedString,@"url",location, @"currentLocation", nil];
	[self.downloader setUrl:urlEncodedString];
	[self.downloader setUserInfo:userInfo];
	[downloader startDownload];

}

#pragma mark DownloaderDelegate implementation
- (void)downloadFinishedWithData:(NSData*)downloadedData userInfo:(NSDictionary*)userInfo{
	
	NSString *identifier = [[userInfo valueForKey:@"identifier"] copy];
	NSData *theData = [downloadedData copy];
	[userInfo release];
	[downloadedData release];

	
	if ([identifier isEqualToString:@"items"]) {
		//
		CLLocation *location=[userInfo objectForKey:@"currentLocation"];
		NSString *replyString = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
		[self processBrowseResponse:replyString];
		[replyString release];	
	}
	

	[identifier release];
	[theData release];
	
	//
	running=NO;
	// tell our interested view controller reload its data, now that downloading has completed
    [[NSNotificationCenter defaultCenter] postNotificationName:SaleItemsDownloadFinished object:nil];


}

- (void)processBrowseResponse:(NSString*)replyString{
	
	DebugLog(@"reply:%@", replyString);
	//json string ie {"status","success", "data":[{sale1},{sale2},{sale3}]}
	//or error like {"status","error", "message":"error happened"}
	NSDictionary *result = [replyString JSONValue];
	if ([[result valueForKey:@"status"] isEqualToString:@"good"]) {
		//success
		NSArray *data = [result objectForKey:@"data"]; //array of dictionary of Sale
		for (NSDictionary *saledic in data) {
			SaleForView *sale = [[[SaleForView alloc] init] autorelease];
			[sale fromDictionary:saledic];
			[self.items addObject:sale];
		}
		
	}else if ([[result valueForKey:@"status"] isEqualToString:@"error"]) {
		//error? server side?
	}

}



- (void)downloadFinishedWithError:(NSError*)error userInfo:(NSDictionary*)userInfo{
	running=NO;
	// tell our interested view controller reload its data, now that downloading has completed
    [[NSNotificationCenter defaultCenter] postNotificationName:SaleItemsDownloadError object:nil];

}




#pragma mark MyCLControllerDelegate implementation Location update
-(void)newLocationUpdateWithLocation:(CLLocation *)location{
	self.currentLocation=location;
	if (lastQueryLocation==nil || [lastQueryLocation distanceFromLocation:location]>100) {
		//only requery server when user moved beyond 100 meters
		self.lastQueryLocation=location;
		[self dowloadSaleItemsFromLocation:self.currentLocation];
	}
	
	
	
}

-(void)newError:(NSString *)text{
	//failed to locate
	DebugLog(@"Failed with location manager %@", text);
}

@end
