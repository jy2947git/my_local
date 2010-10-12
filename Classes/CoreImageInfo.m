// 
//  CoreImageInfo.m
//  mylocal
//
//  Created by You, Jerry on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CoreImageInfo.h"

#import "UIImageToDataTransformer.h"

@implementation CoreImageInfo 

@dynamic imageId;
@dynamic image;
@dynamic blobKey;
@dynamic sale;
+ (void)initialize {
	if (self == [CoreImageInfo class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}
@end
