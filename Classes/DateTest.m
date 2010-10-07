//
//  DateTest.m
//  mylocal
//
//  Created by You, Jerry on 9/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#if UNIT_TEST
#import "GTMSenTestCase.h"
#import "NSDate+NSString.h"
#import "NSString+NSDate.h"

// import your app classes here

@interface DateTest : GTMTestCase
@end

@implementation DateTest

- (void)setUp 
{
	// Run before each test method
}

- (void)tearDown 
{
	// Run after each test method
}

#pragma mark Test Methods

//- (void)testFail 
//{	
//	STAssertNotNULL(NULL, @"test case failed");
//}

//- (void)testMethod
//{
//	NSString *verse = @"John 1:14";
//	
//	// Another test
//	STAssertTrue([verse isEqualToString:@"John 1:14"], @"it's true, check the facts");
//}

- (void)testDateToString{
	NSDate *now = [NSDate date];
	NSString *str = [now stringValue];
	NSLog(@"date is %@, string is %@", [now descriptionWithLocale:[NSLocale currentLocale]], str);
	NSDate *date2 = [str dateValue];
	NSLog(@"string back to date is %@", [date2 descriptionWithLocale:[NSLocale currentLocale]]);
}
@end
#endif
