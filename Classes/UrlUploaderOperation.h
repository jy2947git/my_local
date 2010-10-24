//
//  UrlUploaderOperation.h
//  mylocal
//
//  Created by You, Jerry on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol UrlUploaderOperationDelegate;


@interface UrlUploaderOperation : NSOperation <NSStreamDelegate>{

}

- (id)initWithUrl:(NSURL *)url data:(NSData*)data userInfo:(NSDictionary*)ui delegate:(id)d;

@end
@protocol UrlUploaderOperationDelegate 

- (void)uploadOperationFinishedWithData:(NSData*)data userInfo:(NSDictionary*)userInfo;
- (void)uploadOperationFinishedWithError:(NSError*)error userInfo:(NSDictionary*)userInfo;
@end