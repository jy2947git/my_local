//
//  Sale.m
//  mylocal
//
//  Created by You, Jerry on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Sale.h"
#import "NSString+NSDate.h"
#import "JSON.h"
//#import "SaleItem.h"
#import "ImageInfo.h"

@implementation Sale
@synthesize saleId,userUniqueId, startDate, endDate, latitude, longitude, address1, address2, city, state, zipcode, countryCode, images, phone, email, status, detail, iconImageBlobKey;
@synthesize icon;
- (id)init{
	if (self=[super init]) {
//		NSMutableArray *a = [[NSMutableArray alloc] init];
//		self.items=a;
//		[a release];
		NSMutableArray *i = [[NSMutableArray alloc] init];
		self.images=i;
		[i release];
	}
	return self;
}
- (NSString*)toJson{
	return [[self toDictionary] JSONRepresentation];
}
- (void)fromJson:(NSString*)jsonString{
	[self fromDictionary:[jsonString JSONValue]];
}
- (NSDictionary*)toDictionary{
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setValue:saleId forKey:@"saleId"];
	[dic setValue:userUniqueId forKey:@"userUniqueId"];
	[dic setValue:startDate forKey:@"startDate"];
	[dic setValue:endDate forKey:@"endDate"];
	[dic setValue:latitude forKey:@"latitude"];
	[dic setValue:longitude forKey:@"longitude"];
	[dic setValue:address1 forKey:@"address1"];
	[dic setValue:address2 forKey:@"address2"];
	[dic setValue:city forKey:@"city"];
	[dic setValue:state forKey:@"state"];
	[dic setValue:zipcode forKey:@"zipcode"];
	[dic setValue:countryCode forKey:@"countryCode"];
	[dic setValue:phone forKey:@"phone"];
	[dic setValue:email forKey:@"email"];
	[dic setValue:detail forKey:@"detail"];
	[dic setValue:iconImageBlobKey forKey:@"iconImageBlobKey"];
	//items need to handle specially, transform to Array of Dictionary since JSON can only handle the limited types
//	NSMutableArray *arrItems = [[[NSMutableArray alloc] init] autorelease];
//	for (SaleItem *item in self.items) {
//		[arrItems addObject:[item toDictionary]];
//	}
	
	//images are handled seperately from sale. so, for now leave it out.
	return dic;
}
- (void)fromDictionary:(NSDictionary*)dic{
	self.saleId=[dic valueForKey:@"saleId"];
	self.userUniqueId=[dic valueForKey:@"userUniqueId"];
	self.startDate= [dic valueForKey:@"startDate"];
	self.endDate=[dic valueForKey:@"endDate"];
	self.latitude=[dic valueForKey:@"latitude"];
	self.longitude=[dic valueForKey:@"longitude"];
	self.address1=[dic valueForKey:@"address1"];
	self.address2=[dic valueForKey:@"address2"];
	self.city=[dic valueForKey:@"city"];
	self.state=[dic valueForKey:@"state"];
	self.zipcode=[dic valueForKey:@"zipcode"];
	self.countryCode=[dic valueForKey:@"countryCode"];
	self.detail=[dic valueForKey:@"detail"];
	self.phone=[dic valueForKey:@"phone"];
	self.email=[dic valueForKey:@"email"];
	self.iconImageBlobKey = [dic valueForKey:@"iconImageBlobKey"];
	//convert from Array of Dictionary to Array of SaleItem
//	NSArray *arrItems = (NSArray*)[dic objectForKey:@"items"];
//	for (NSDictionary *dic in arrItems) {
//		SaleItem *item = [[[SaleItem alloc] init] autorelease];
//		[item fromDictionary:dic];
//		[self addSaleItem:item];
//	}
	NSArray *jsonImageInfos = (NSArray*)[dic objectForKey:@"imageJsons"];
	for (NSString *jsonImageInfo in jsonImageInfos) {
		ImageInfo *imageInfo = [[ImageInfo alloc] init];
		[imageInfo fromJson:jsonImageInfo];
		[self.images addObject:imageInfo];
		[imageInfo release];
	}
}

- (void)dealloc{
	[icon release];
	[latitude release];
	[longitude release];
	[phone release];
	[email release];
	[images release];
	[saleId release];
	[userUniqueId release];
//	[items release];
	[startDate release];
	[endDate release];
	[address1 release];
	[address2 release];
	[city release];
	[state release];
	[zipcode release];
	[countryCode release];
	[status release];
	[detail release];
	[iconImageBlobKey release];
	[super dealloc];
}

//- (void)addSaleItem:(SaleItem*)item{
//	[self.items addObject:item];
//}
@end
