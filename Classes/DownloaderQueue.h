//
//  DownloaderQueue.h
//  mylocal
//
//  Created by You, Jerry on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UrlDownloaderOperation;
@interface DownloaderQueue : NSObject {

	NSOperationQueue *queue;
}
@property(nonatomic, retain) NSOperationQueue *queue;
- (void)enqueue:(UrlDownloaderOperation*)op;
@end
