// 
//  CoreSale.m
//  mylocal
//
//  Created by You, Jerry on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CoreSale.h"
#import "UIImageToDataTransformer.h"

@implementation CoreSale 

@dynamic detail;
@dynamic address1;
@dynamic phone;
@dynamic longitude;
@dynamic saleId;
@dynamic userUniqueId;
@dynamic latitude;
@dynamic countryCode;
@dynamic stateCode;
@dynamic address2;
@dynamic zipcode;
@dynamic city;
@dynamic startDate;
@dynamic email;
@dynamic dataVersion;
@dynamic images;
//
// how the transformer work, I had to put below manually (copied from the Locations sample app)
// this is not ideal since if we change the data model and regenerate the classes, this additional
// code will be lost!
//
+ (void)initialize {
	if (self == [CoreSale class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}
@end
