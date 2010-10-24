//
//  SaleDetailViewController.h
//  mylocal
//
//  Created by You, Jerry on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <iAd/iAd.h>

@class CLLocation;
@class ADBannerView;
@class CoreEvent;
@interface SaleDetailViewController : UIViewController <UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate, MKReverseGeocoderDelegate, ADBannerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	UITextField *addressInput;
	UITextField *summaryInput;
	NSMutableArray *imageViews;
	CLLocation *myLocation;
	ADBannerView *adView;
	BOOL bannerIsVisible;
	UIImageView *photoGrid;
	MKReverseGeocoder *reverseGeocoder;
	NSString *currentAddress;
	CoreEvent *event;
	UITapGestureRecognizer *tapRecognizer;
}
@property (nonatomic, retain) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic, retain) CoreEvent *event;
@property(nonatomic, assign) BOOL bannerIsVisible;
@property(nonatomic, retain) IBOutlet UITextField *summaryInput;
@property(nonatomic, retain) IBOutlet UITextField *addressInput;
@property(nonatomic, retain) NSMutableArray *imageViews;
@property(nonatomic, retain) CLLocation *myLocation;
@property(nonatomic, retain) ADBannerView *adView;
@property(nonatomic, retain) IBOutlet UIImageView *photoGrid;
@property(nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
@property(nonatomic, retain) NSString *currentAddress;
- (IBAction)takePictureButtonPressed:(id)sender;
- (IBAction)choosePhotoButtonPressed:(id)sender;
- (void)doneButtonWasPressed:(id)sender;
@end
