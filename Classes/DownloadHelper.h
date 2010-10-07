//
//  DownloadHelper.h
//  mylocal
//
//  a helper class to manage http get, post calls
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloaderDelegate;
@interface DownloadHelper : NSObject {
	id <DownloaderDelegate> delegate;
    NSString *url;
    NSURLConnection         *connection;
    NSMutableData           *downloadedData;
	NSMutableData *activeDownload;
	NSDictionary *userInfo;
}
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSDictionary *userInfo;;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *downloadedData;
@property (nonatomic, assign) id <DownloaderDelegate> delegate;
@property (nonatomic, retain) NSMutableData *activeDownload;
- (void)startDownload;
- (void)cancelDownload;
- (id)initWithUserInfo:(NSDictionary*)ui Url:(NSString*)encodedUrlString delegate:(id)del;
@end

@protocol DownloaderDelegate 

- (void)downloadFinishedWithData:(NSData*)data userInfo:(NSDictionary*)userInfo;
- (void)downloadFinishedWithError:(NSError*)error userInfo:(NSDictionary*)userInfo;
@end
