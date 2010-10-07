//
//  SaleItemHelper.h
//  mylocal
//
//  This is the helper class to manage the sale items. It provides functions like
//  browse, add, search etc. It is the single handler of the backend/server interactions
//  regarding sale items; the helper works with backend asynchronously - it send http calls
//  and immediately return; once it receives response, it will send local notofication to
//  notify the parts which are interested with the data (usually the view controllers)
//
//  This class relies on the DownloadHelper to handle the real downloading gien URL, and
//  the SaleItemParser to process the downloaded content.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadHelper.h"
#import "MyCLController.h"
#import "CoreLocation/CLLocation.h"

extern NSString *SaleItemsDownloadFinished;
extern NSString *SaleItemsDownloadError;
@interface SalesDownloader : NSObject <DownloaderDelegate,MyCLControllerDelegate>{
	NSMutableArray *items;
	DownloadHelper *downloader;
	CLLocation *lastQueryLocation;
	CLLocation *currentLocation;
	NSMutableArray *delegates;
}
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) DownloadHelper *downloader;
@property(nonatomic, retain) CLLocation *lastQueryLocation;
@property(nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSMutableArray *delegates;

-(void)dowloadSaleItemsFromLocation:(CLLocation *)currentLocation;
+ (SalesDownloader *)sharedInstance;
//- (void)registerListener:(id)listener;
//- (void)deregisterListener:(id)listener;
- (void)forceToRefreshSaleItems;
- (BOOL)isRunning;
@end
