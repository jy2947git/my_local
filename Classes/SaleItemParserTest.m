//
//  SaleItemParserTest.m
//  mylocal
//
//  Created by You, Jerry on 9/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "GTMSenTestCase.h"
#import "NSDate+NSString.h"
#import "NSString+NSDate.h"
#import "Sale.h"
#import "SaleItem.h"
#import "JSON.h"

#if UNIT_TEST
#import "GTMSenTestCase.h"


// import your app classes here

@interface SaleItemParserTest : GTMTestCase
@end

@implementation SaleItemParserTest

- (void)setUp 
{
	// Run before each test method
}

- (void)tearDown 
{
	// Run after each test method
}

#pragma mark Test Methods

- (void)testSaleToJSON{
	Sale *s = [[[Sale alloc] init] autorelease];
	s.identifier=@"sale1";
	s.sellerIdentity=@"1111";
	s.startDate=@"2010-10-01";
	s.expirationDate=@"2010-10-02";
	[s.images addObject:@"http://image.google.com/12345"];
	[s.images addObject:@"http://image.google.com/93903"];
	s.phone=@"123-344-3033";
	s.email=@"test@test.com";
	
	NSLog(@"translated to string:%@", [[s toDictionary] JSONRepresentation]);

}

- (void)testSaleItemToJSON{
	SaleItem *item = [[[SaleItem alloc] init] autorelease];
	item.imageUrl=@"http://image.google.com/93903";
	item.identifier=@"1234";
	NSLog(@"%@",[item toDictionary]);
	NSLog(@"sale item:%@", [[item toDictionary] JSONRepresentation]);
}
- (void)testJsonToDic{
	NSLog(@"Parsed some JSON: %@", [@"[1,2,3,true,false,null]" JSONValue]);
	NSLog(@"Parsed some JSON: %@", [@"{\"status\":\"good\"}" JSONValue]);
	
}

- (void)testSaleItem{
	SaleItem *item = [[[SaleItem alloc] init] autorelease];
	item.imageUrl=@"http://image.google.com/93903";
	item.identifier=@"1234";
	NSString *jstring = [item toJson];
	NSLog(@"json string:%@", jstring);
	SaleItem *item2 = [[[SaleItem alloc] init] autorelease];
	[item2 fromJson:jstring];
	NSLog(@"SaleItem2:%@", [item2 toDictionary]);
}

@end
#endif