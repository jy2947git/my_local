//
//  ImageInfo.m
//  mylocal
//
//  Created by You, Jerry on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageInfo.h"
#import "JSON.h"

@implementation ImageInfo
@synthesize imageId, saleId, status, imageBlobKey, imageIconBlobKey;

- (void)dealloc{
	[imageId release];
	[saleId release];
	[status release];
	[imageBlobKey release];
	[imageIconBlobKey release];
	[super dealloc];
}


- (NSString*)toJson{
	return [[self toDictionary] JSONRepresentation];
}
- (void)fromJson:(NSString*)jsonString{
	[self fromDictionary:[jsonString JSONValue]];
}
- (NSDictionary*)toDictionary{
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setValue:self.imageId forKey:@"imageId"];
	[dic setValue:self.saleId forKey:@"saleId"];
	[dic setValue:self.status forKey:@"status"];
	[dic setValue:self.imageBlobKey forKey:@"imageBlobKey"];
	[dic setValue:self.imageIconBlobKey forKey:@"imageIconBlobKey"];
	return dic;
}
- (void)fromDictionary:(NSDictionary*)dictionary{
	self.imageId = [dictionary valueForKey:@"imageId"];
	self.saleId = [dictionary valueForKey:@"saleId"];
	self.status = [dictionary valueForKey:@"status"];
	self.imageBlobKey = [dictionary valueForKey:@"imageBlobKey"];
	self.imageIconBlobKey = [dictionary valueForKey:@"imageIconBlobKey"];
	
}
@end
