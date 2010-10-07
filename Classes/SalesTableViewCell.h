//
//  SalesTableViewCell.h
//  mylocal
//
//  Created by You, Jerry on 10/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SaleForView;
@interface SalesTableViewCell : UITableViewCell {
	UIImageView *icon;
	UILabel *address1Label;
	UILabel *cityLabel;
	UILabel *zipcodeLabel;
	UILabel *distanceLabel;
	SaleForView *saleView;
}
@property(nonatomic, retain) IBOutlet UIImageView *icon;
@property(nonatomic, retain) IBOutlet UILabel *address1Label;
@property(nonatomic, retain) IBOutlet UILabel *cityLabel;
@property(nonatomic, retain) IBOutlet UILabel *zipcodeLabel;
@property(nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property(nonatomic, retain) SaleForView *saleView;

- (void)setSale:(SaleForView *)_sale;
- (void)setDistance:(double)_distance;
@end
