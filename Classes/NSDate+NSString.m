//
//  NSDate+NSString.m
//  mylocal
//
//  Created by You, Jerry on 9/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSDate+NSString.h"


@implementation  NSDate (NSDate_NSString)
- (NSString*)stringValue{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *str = [dateFormatter stringFromDate:self];
	return str;
}
@end
