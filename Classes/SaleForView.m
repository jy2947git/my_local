//
//  SaleForView.m
//  mylocal
//
//  Created by You, Jerry on 10/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SaleForView.h"


@implementation SaleForView
@synthesize icon, iconUrl;

- (void)dealloc{
	[icon release];
	[iconUrl release];
	[super dealloc];
}
@end
