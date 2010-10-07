//
//  SaleItem.m
//  mylocal
//
//  Created by You, Jerry on 9/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SaleItem.h"
#import "JSON.h"

@implementation SaleItem
@synthesize identifier,description, barcode, url, imageUrl;

- (void)dealloc{
	[identifier release];
	[description release];
	[barcode release];
	[url release];
	[imageUrl release];
	[super dealloc];
}

- (NSDictionary*)toDictionary{
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setValue:identifier forKey:@"identifier"];
	[dic setValue:description forKey:@"description"];
	[dic setValue:barcode forKey:@"barcode"];
	[dic setValue:url forKey:@"url"];
	[dic setValue:imageUrl forKey:@"imageUrl"];
	
	return dic;
}
- (void)fromDictionary:(NSDictionary*)dictionary{
	self.identifier=[dictionary valueForKey:@"identifier"];
	self.description=[dictionary valueForKey:@"description"];
	self.barcode=[dictionary valueForKey:@"barcode"];
	self.url=[dictionary valueForKey:@"url"];
	self.imageUrl=[dictionary valueForKey:@"imageUrl"];
}
- (NSString*)toJson{
	return [[self toDictionary] JSONRepresentation];
}
- (void)fromJson:(NSString*)jsonString{
	[self fromDictionary:[jsonString JSONValue]];
}
@end
