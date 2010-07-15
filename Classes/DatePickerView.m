//
//  DatePickerView.m
//  mylocal
//
//  Created by Junqiang You on 5/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DatePickerView.h"


@implementation DatePickerView
@synthesize datePicker;
@synthesize doneButton;

-(id)initWithFrame:(CGRect)frame AndDate:(NSDate*)date{
	if((self = [super initWithFrame:frame])){
		self.backgroundColor=[UIColor blueColor];
		//create the picker and done button
		UIDatePicker *p = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
		self.datePicker=p;
		[p release];
		
		if(date!=nil){
			[self.datePicker setDate:date animated:YES];
		}
		UIButton *b=[UIButton buttonWithType:UIButtonTypeRoundedRect];
		b.frame=CGRectMake(130, 225, 80, 30) ;
		[b setTitle:@"Done" forState:UIControlStateNormal];
		self.doneButton=b;
		//
		[self addSubview:self.datePicker];
		[self addSubview:self.doneButton];
	}
	
	return self;
	
}
- (void)dealloc {
	[doneButton release];
	[datePicker release];
	[super dealloc];
}
@end
