// 
//  CorePhoto.m
//  mylocal
//
//  Created by You, Jerry on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CorePhoto.h"
#import "UIImageToDataTransformer.h"

@implementation CorePhoto 

@dynamic blobKey;
@dynamic image;
//
// how the transformer work, I had to put below manually (copied from the Locations sample app)
// this is not ideal since if we change the data model and regenerate the classes, this additional
// code will be lost!
//
+ (void)initialize {
	if (self == [CorePhoto class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}
@end
