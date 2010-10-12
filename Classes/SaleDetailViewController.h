//
//  SaleDetailViewController.h
//  mylocal
//
//  Created by You, Jerry on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MKReverseGeocoder.h"
#import <iAd/iAd.h>

@class CLLocation;
@class ADBannerView;
@interface SaleDetailViewController : UIViewController <MKReverseGeocoderDelegate, ADBannerViewDelegate>{
	UILabel *addressLabel;
	NSMutableArray *imageViews;
	CLLocation *myLocation;
	ADBannerView *adView;
	BOOL bannerIsVisible;
	UIImageView *photoGrid;
}
@property(nonatomic, assign) BOOL bannerIsVisible;
@property(nonatomic, retain) IBOutlet UILabel *addressLabel;
@property(nonatomic, retain) NSMutableArray *imageViews;
@property(nonatomic, retain) CLLocation *myLocation;
@property(nonatomic, retain) ADBannerView *adView;
@property(nonatomic, retain) IBOutlet UIImageView *photoGrid;
- (IBAction)takePictureButtonPressed:(id)sender;
@end
