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
#import "UIImage+Resize.h"
#import "UIImage+Alpha.h"
#import "UIImage+RoundedCorner.h"
#import "LocalImageCache.h"
#import "CoreEvent.h"
#import "CorePhoto.h"

#define location_textfield 8001
#define summary_textfield 8002
#define photo_valid 9000

@interface SaleDetailViewController ()
- (void)setUpPhotoImagesView;
@end

@implementation SaleDetailViewController
@synthesize tapRecognizer,myLocation, addressInput, imageViews, bannerIsVisible, photoGrid, currentAddress, reverseGeocoder, summaryInput, event;



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
	NSMutableArray *a = [[NSMutableArray alloc] init];
	self.imageViews=a;
	[a release];

	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonWasPressed:)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	self.addressInput.userInteractionEnabled=NO;
	//reverse-geocoding to find the location address
	if (self.event.location!=nil) {
		self.addressInput.text=self.event.location;
	}else if (currentAddress==nil) {
		self.addressInput.text=@"finding your address...";
		DebugLog(@"current location is %@", self.myLocation);
		self.reverseGeocoder =
		[[[MKReverseGeocoder alloc] initWithCoordinate:myLocation.coordinate] autorelease];
		reverseGeocoder.delegate = self;
		[reverseGeocoder start];
		DebugLog(@"start reverse geocoding...");
	}else {
		self.addressInput.text=self.currentAddress;
	}
	
	if (self.event.summary!=nil) {
		self.summaryInput.text=self.event.summary;
	}else {
		self.summaryInput.text=@"Mary & Jack Welth";
	}

	
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

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField.tag==location_textfield) {
		[self.event setLocation:textField.text];
	}else if (textField.tag==summary_textfield) {
		[self.event setSummary:textField.text];
	}else {
		NSLog(@"No match found to the text field!");
	}

	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
	return YES;
}

- (void)setUpPhotoImagesView{
	UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder.png"];
	//programmingly create the image-views, put in the array and add on the photo-grid
	float imageWidth=60;
	float imageHeight=60;
	float space=2;
	float spaceFromLeft=2;
	float spaceFromTop=2;

	NSSet *existingPhotos = self.event.photos;
	NSEnumerator *enumerator = [existingPhotos objectEnumerator];
	int imageViewCount=-1;
	for (int row=0; row<3; row++) {
		for (int col=0; col<3; col++) {
			imageViewCount = imageViewCount+1;
			CGRect frame = CGRectMake(spaceFromLeft+col*(imageWidth+space), spaceFromTop+row*(imageHeight+space), imageWidth, imageHeight);
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
			imageView.userInteractionEnabled=NO;
			
						[self.imageViews insertObject:imageView atIndex:imageViewCount];
			CorePhoto *photo = [enumerator nextObject];
			
			if (photo!=nil && photo.thumbNailImage!=nil) {
				DebugLog(@"Found existing local event photo %@", [photo objectID]);
				imageView.image=photo.thumbNailImage;
				imageView.tag=photo_valid+imageViewCount;
				imageView.userInteractionEnabled=YES;
				UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
				[imageView addGestureRecognizer:recognizer];
				recognizer.delegate = self;
				[recognizer release];
				
			}else{
				imageView.image=placeholderImage;
				imageView.tag=2000+imageViewCount;
			}
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
	self.tapRecognizer = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[tapRecognizer release];
	[summaryInput release];
	[event release];
	[photoGrid release];
	[myLocation release];
	[addressInput release];
	[imageViews release];
	
    [super dealloc];
}
- (IBAction)choosePhotoButtonPressed:(id)sender{
	DebugLog(@"taking picture!");
	
	UIImagePickerController *camV = [[UIImagePickerController alloc] init];
	
	camV.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
	camV.delegate = self;
	camV.allowsEditing = YES;
	
	[self presentModalViewController:camV animated:YES];
	[camV release];
}

- (IBAction)takePictureButtonPressed:(id)sender{
	DebugLog(@"taking picture!");
	
	UIImagePickerController *camV = [[UIImagePickerController alloc] init];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)
	{
		camV.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	else
	{
		camV.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	}
	camV.delegate = self;
	camV.allowsEditing = YES;
	
	[self presentModalViewController:camV animated:YES];
	[camV release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editingInfo
{
	
	[self dismissModalViewControllerAnimated:YES];
	//resize image to be used to two different sizes - icon and normal. This is necessary because the iPhone4 image is way too big, to cause
	//memory issue and server upload problem.
	UIImage *thumbnail = [img thumbnailImage:75 transparentBorder:2 cornerRadius:2 interpolationQuality:1];
	UIImage *resizedImage = [img resizedImage:CGSizeMake(320, 640) interpolationQuality:kCGInterpolationMedium];
	//create icon image, put in the view, save the image to local and queue to upload to server
	for (UIImageView *iv in self.imageViews) {
		if (iv.tag<photo_valid) {
			iv.image=thumbnail;
			iv.tag=iv.tag+photo_valid;
			//create a CorePhoto and add to current CoreEvent
			CorePhoto *newPhoto = [LocalImageCache createPhotoWithThumbNailImage:thumbnail image:resizedImage];
			[self.event addPhotosObject:newPhoto];
			[LocalImageCache saveEvent:self.event];
			break;
		}
	}
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);  
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
	
	return;
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {  
	NSString *message;  
	NSString *title;  
	if (!error) {  
		title = NSLocalizedString(@"Success", @"");  
		message = NSLocalizedString(@"Pictures added succesfully to photo library", @"");  
    } else {  
		title = NSLocalizedString(@"Failed !", @"");  
		message = [error description];  
	}  
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title  
													message:message  
												   delegate:nil  
										  cancelButtonTitle:NSLocalizedString(@"OK", @"")  
										  otherButtonTitles:nil]; 
	[self performSelector:@selector(deselect1:) withObject:alert afterDelay:2.0f];	
//	[alert show];  no show message
	[alert release];  
}  


-(void)deselect1:(UIAlertView *)testView{
	
	[testView dismissWithClickedButtonIndex:1 animated:YES];
	
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
	DebugLog(@"failed to look up location %@", [error localizedDescription]);
	self.addressInput.userInteractionEnabled=YES;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"  
													message:@"Could not determine your address, please enter it manually"  
												   delegate:nil  
										  cancelButtonTitle:NSLocalizedString(@"OK", @"")  
										  otherButtonTitles:nil]; 
	[alert show];
	[alert release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	NSLog(@"Geocoder completed");
	NSString *addressFound = [[NSString alloc]initWithFormat:@"%@,%@,%@",placemark.locality, placemark.administrativeArea, placemark.postalCode];
	self.addressInput.text=addressFound;
	self.currentAddress=addressFound;
	[addressFound release];
	[geocoder release];
	self.addressInput.userInteractionEnabled=YES;
}
	
- (BOOL)allowActionToRun{
	return YES;
}


- (void)doneButtonWasPressed:(id)sender{
	//save the core-event
	[LocalImageCache saveDoneEvent:self.event];
	[self.navigationController popViewControllerAnimated:YES];
}

/*
 In response to a tap gesture, show the image view appropriately then make it fade out in place.
 */
- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
	int viewTag = recognizer.view.tag;
	DebugLog(@"user taped %i", viewTag-photo_valid);
//    CGPoint location = [recognizer locationInView:self.view];
//    [self showImageWithText:@"tap" atPoint:location];
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.5];
//    imageView.alpha = 0.0;
//    [UIView commitAnimations];
}
@end
