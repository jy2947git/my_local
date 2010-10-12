//
//  SaleDetailViewController.m
//  mylocal
//
//  Created by You, Jerry on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SaleDetailViewController.h"
#import "GlobalHeader.h"
#import "CoreLocation/CLLocation.h"
#import "GlobalConfiguration.h"
#import "MapKit/MKPlacemark.h"

@interface SaleDetailViewController ()
- (void)setUpAdView;
- (void)setUpPhotoImagesView;
@end

@implementation SaleDetailViewController
@synthesize myLocation, addressLabel, imageViews, adView, bannerIsVisible, photoGrid;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//reverse-geocoding to find the location address
	MKReverseGeocoder *appleReverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:self.myLocation.coordinate];
	appleReverseGeocoder.delegate=self;
	[appleReverseGeocoder start];
	DebugLog(@"start reverse geocoding...");
	[appleReverseGeocoder retain];
	//ad view
//	[self setUpAdView];
	//placeholder for the 9 images
	//set up the image view grid
	[self setUpPhotoImagesView];

}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)setUpPhotoImagesView{
	UIImage *placeholderImage = [UIImage imageNamed:@"placeholder.png"];
	//programmingly create the image-views, put in the array and add on the photo-grid
	float imageWidth=80;
	float imageHeight=80;
	float space=5;
	float spaceFromLeft=10;
	float spaceFromTop=10;
	for (int row=0; row<3; row++) {
		for (int col=0; col<3; col++) {
			CGRect frame = CGRectMake(spaceFromLeft+col*(imageWidth+space), spaceFromTop+row*(imageHeight+space), imageWidth, imageHeight);
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
			[self.
			imageView.image=placeholderImage;
			[self.photoGrid addSubview:imageView];
			
		}
	}
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[photoGrid release];
	[myLocation release];
	[addressLabel release];
	[imageViews release];
	adView.delegate=nil;
	[adView release];
    [super dealloc];
}

- (IBAction)takePictureButtonPressed:(id)sender{
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
	DebugLog(@"failed to look up location");
	[geocoder release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	NSLog(@"Geocoder completed");
	NSString *addressFound = [[NSString alloc]initWithFormat:@"%@ %@,%@,%@,%@,%@",placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode, placemark.country];
	self.addressLabel.text=addressFound;
	[addressFound release];
	[geocoder release];
}
	
- (BOOL)allowActionToRun{
	return YES;
}


- (void)setUpAdView{
	adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
	adView.frame = CGRectOffset(adView.frame, 0, -50);
	adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifier320x50];
	adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
	[self.view addSubview:adView];
	adView.delegate=self;
	self.bannerIsVisible=NO;
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	if (!self.bannerIsVisible)
	{
		[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
		// banner is invisible now and moved out of the screen on 50 px
		banner.frame = CGRectOffset(banner.frame, 0, 50);
		[UIView commitAnimations];
		self.bannerIsVisible = YES;
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	if (self.bannerIsVisible)
	{
		[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		// banner is visible and we move it out of the screen, due to connection issue
		banner.frame = CGRectOffset(banner.frame, 0, -50);
		[UIView commitAnimations];
		self.bannerIsVisible = NO;
	}
}
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	NSLog(@"Banner view is beginning an ad action");
	BOOL shouldExecuteAction = YES;
	if (!willLeave && shouldExecuteAction)
    {
		// stop all interactive processes in the app
		// [video pause];
		// [audio pause];
    }
	return shouldExecuteAction;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	// resume everything you've stopped
	// [video resume];
	// [audio resume];
}

@end
