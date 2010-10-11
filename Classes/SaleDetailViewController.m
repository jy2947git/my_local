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
@implementation SaleDetailViewController
@synthesize myLocation, addressLabel, icon0, icon1,icon2,icon3,icon4,icon5,icon6,icon7,icon8;
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
	//placeholder for the 9 images
	UIImage *placeholderImage = [UIImage imageNamed:@"placeholder.png"];
	icon0.image=placeholderImage;
	icon1.image=placeholderImage;
	icon2.image=placeholderImage;
	icon3.image=placeholderImage;
	icon4.image=placeholderImage;
	icon5.image=placeholderImage;
	icon6.image=placeholderImage;
	icon7.image=placeholderImage;
	icon8.image=placeholderImage;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[myLocation release];
	[addressLabel release];
	[icon0 release];
	[icon1 release];
	[icon2 release];
	[icon3 release];
	[icon4 release];
	[icon5 release];
	[icon6 release];
	[icon7 release];
	[icon8 release];
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
@end
