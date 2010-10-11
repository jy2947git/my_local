//
//  SalesTableViewCell.m
//  mylocal
//
//  Created by You, Jerry on 10/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SalesTableViewCell.h"
#import "Sale.h"

@implementation SalesTableViewCell
@synthesize icon, address1Label, cityLabel, zipcodeLabel, distanceLabel, saleView;

- (void)dealloc{
	[icon release];
	[address1Label release];
	[cityLabel release];
	[zipcodeLabel release];
	[distanceLabel release];
	[saleView release];
	[super dealloc];
}

- (void)setSale:(Sale *)_sale{
	DebugLog(@"%@",_sale);
	self.saleView=_sale;
	//do not set image here, the table-view-controller will handle the downloading and displaying
	//of the image in all the visible cells

	address1Label.text=_sale.address1;
	cityLabel.text=_sale.city;
	zipcodeLabel.text=_sale.zipcode;
}

- (void)setDistance:(double)_distance{
	distanceLabel.text=[NSString stringWithFormat:@"%f", _distance];
}
@end
