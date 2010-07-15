//
//  InputLabel.m
//  mylocal
//
//  Created by Junqiang You on 5/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InputLabel.h"



@implementation InputLabel
@synthesize controller;

- (id)initWithFrame:(CGRect)aRect{
	if((self=[super initWithFrame:aRect])!=nil){
		self.userInteractionEnabled=YES;
		self.textColor=[UIColor blackColor];
		self.backgroundColor=[UIColor grayColor];
		
	}
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self.controller showDatePicker:self];
}
- (void)dealloc {

	[super dealloc];
}
@end
