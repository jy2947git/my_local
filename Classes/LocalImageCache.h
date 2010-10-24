//
//  LocalImageCache.h
//  mylocal
//
//  To reduce the times we hit the server for images, we store the downloaded sale/image data through CoreData
//  this is a core-data utility to save/query/delete core-data objects: CoreSale, CoreImageInfo
// 
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoreEvent;
@class CorePhoto;
@interface LocalImageCache : NSObject {
	
}
+ (CorePhoto*)saveImage:(UIImage*)data withKey:(NSString*)key;
+ (UIImage*)getImageFromKey:(NSString*)key;
+ (void)saveEvent:(CoreEvent*)event;
+ (CoreEvent*)getCurrentEditingEvent;
+ (CoreEvent*)getPendingEvent;
+ (void)saveDoneEvent:(CoreEvent*)event;
+ (CorePhoto*)createPhotoWithThumbNailImage:(UIImage*)thumbNail image:(UIImage*)img;
@end
