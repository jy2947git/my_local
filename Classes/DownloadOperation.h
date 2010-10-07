//
//  DownloadOperation.h
//  mylocal
//
//  Created by You, Jerry on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadHelper.h"


@interface DownloadOperation : NSOperation {
	NSDictionary *userInfo;
	NSString *urlString;
	id<DownloaderDelegate> delegate;
	DownloadHelper *downloadHelper;
}
@property (nonatomic, retain) DownloadHelper *downloadHelper;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) id<DownloaderDelegate> delegate;
- (id)initWithUserInfo:(NSDictionary*)ui url:(NSString*)url delegate:(id <DownloaderDelegate>)d;
@end
