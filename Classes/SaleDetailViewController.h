//
//  SaleDetailViewController.h
//  mylocal
//
//  Created by You, Jerry on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MKReverseGeocoder.h"
@class CLLocation;
@interface SaleDetailViewController : UIViewController <MKReverseGeocoderDelegate>{
	UILabel *addressLabel;
	UIImageView *icon0;
	UIImageView *icon1;
	UIImageView *icon2;
	UIImageView *icon3;
	UIImageView *icon4;
	UIImageView *icon5;
	UIImageView *icon6;
	UIImageView *icon7;
	UIImageView *icon8;
	CLLocation *myLocation;
}
@property(nonatomic, retain) IBOutlet UILabel *addressLabel;
@property(nonatomic, retain) IBOutlet UIImageView *icon0;
@property(nonatomic, retain) IBOutlet UIImageView *icon1;
@property(nonatomic, retain) IBOutlet UIImageView *icon2;
@property(nonatomic, retain) IBOutlet UIImageView *icon3;
@property(nonatomic, retain) IBOutlet UIImageView *icon4;
@property(nonatomic, retain) IBOutlet UIImageView *icon5;
@property(nonatomic, retain) IBOutlet UIImageView *icon6;
@property(nonatomic, retain) IBOutlet UIImageView *icon7;
@property(nonatomic, retain) IBOutlet UIImageView *icon8;
@property(nonatomic, retain) CLLocation *myLocation;
- (IBAction)takePictureButtonPressed:(id)sender;
@end
