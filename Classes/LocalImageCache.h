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


@interface LocalImageCache : NSObject {
	
}
+ (void)saveImage:(UIImage*)data withKey:(NSString*)key;
+ (UIImage*)getImageFromKey:(NSString*)key;

@end
