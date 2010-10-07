//
//  NSString+NSDate.m
//  mylocal
//
//  Created by You, Jerry on 9/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+NSDate.h"


@implementation  NSString (NSString_NSDate)

- (NSDate*)dateValue{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSDate *date = [dateFormatter dateFromString:self];
	
	return date;
}
@end
