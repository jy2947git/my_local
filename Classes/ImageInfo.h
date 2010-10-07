//
//  ImageInfo.h
//  mylocal
//
//  Created by You, Jerry on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageInfo : NSObject {
	NSString *imageId;
	NSString *saleId;
	NSString *status;
	NSString *imageBlobKey;
	NSString *imageIconBlobKey;
}
@property (nonatomic, copy) NSString *imageId;
@property (nonatomic, copy) NSString *saleId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *imageBlobKey;
@property (nonatomic, copy) NSString *imageIconBlobKey;

- (NSDictionary*)toDictionary;
- (void)fromDictionary:(NSDictionary*)dictionary;
- (NSString*)toJson;
- (void)fromJson:(NSString*)jsonString;

@end
