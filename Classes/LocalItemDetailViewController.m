//
//  LocalItemDetailViewController.m
//  mylocal
//
//  Created by Junqiang You on 5/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocalItemDetailViewController.h"
#import "GlobalHeader.h"
#import "mylocalAppDelegate.h"
#import "CoreLocation/CLLocation.h"
#import "InternetUtility.h"
#import "InputLabel.h"
#import "DatePickerView.h"
#import "GlobalConfiguration.h"
#import "MapKit/MKPlacemark.h"
#import "LocalItemsTableViewController.h"

@implementation LocalItemDetailViewController
@synthesize address;
@synthesize description;
@synthesize startDateString;
@synthesize endDateString;
@synthesize datePicker;
@synthesize selectedStartDate;
@synthesize selectedEndDate;
@synthesize doneEditingTextArea;
@synthesize saleItemId;
@synthesize isEditing;
@synthesize deleteButton;
@synthesize isNew;
@synthesize listController;
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.isEditing=NO;
		self.isNew=YES;
		self.saleItemId=@"";
		self.title=NSLocalizedString(@"Sale",@"Sale");
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[UIApplication sharedApplication].delegate;
	//if it is new, then try to figure out the current location by reverse geocoding
	if(self.isNew){
		if(delegate.currentLocationAddress==nil){
			MKReverseGeocoder *appleReverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:delegate.currentLocation.coordinate];
			appleReverseGeocoder.delegate=self;
			[appleReverseGeocoder start];
			DebugLog(@"start reverse geocoding...");
			[appleReverseGeocoder retain];
		}else{
			self.address.text=delegate.currentLocationAddress;
		}
	}

	//add start datea and end date label
	InputLabel *start = [[InputLabel alloc] initWithFrame:CGRectMake(103, 228, 195, 26)];
	self.startDateString=start;
	self.startDateString.controller=self;
	self.startDateString.tag=TAG_START_DATE;
	[start release];
	InputLabel *end = [[InputLabel alloc] initWithFrame:CGRectMake(103, 257, 195, 26)];
	self.endDateString=end;
	self.endDateString.tag=TAG_END_DATE;
	self.endDateString.controller=self;
	[end release];
	[self.view addSubview:self.startDateString];
	[self.view addSubview:self.endDateString];
	//description text view
	self.description.delegate=self;
	self.doneEditingTextArea.hidden=YES;
	
	//now take care of the edit-detail
	if(self.isNew){
		//new item mode
		UIBarButtonItem	*saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
		self.navigationItem.rightBarButtonItem = saveItem;
		[saveItem release];
		//call reverse-geocoder to find the location address from latitude and longitude
	}else{
		//view or edit mode
		[self startDetailForViewOrEdit];
		if(self.isEditing){
			UIBarButtonItem	*saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
			self.navigationItem.rightBarButtonItem = saveItem;
			[saveItem release];
			//add the delete button
			if(self.deleteButton==nil){
				UIButton *d=[UIButton buttonWithType:UIButtonTypeRoundedRect];
				self.deleteButton=d;
			}
			self.deleteButton.frame=CGRectMake(118, 295, 83, 35);
			[self.deleteButton setTitle:NSLocalizedString(@"Remove",@"Remove") forState:UIControlStateNormal];
			[self.deleteButton setTitle:NSLocalizedString(@"Remove",@"Remove") forState:UIControlStateHighlighted];
			
			[self.view addSubview:self.deleteButton];
			[self.deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
		}else{
			self.address.userInteractionEnabled=NO;
			self.description.userInteractionEnabled=NO;
			self.startDateString.userInteractionEnabled=NO;
			self.endDateString.userInteractionEnabled=NO;
		}
	}
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
	DebugLog(@"failed to look up location");
	[geocoder release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	NSLog(@"Geocoder completed");
	NSString *addressFound = [[NSString alloc]initWithFormat:@"%@ %@,%@,%@,%@,%@",placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode, placemark.country];
	self.address.text=addressFound;
	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[UIApplication sharedApplication].delegate;
	delegate.currentLocationAddress=addressFound;
	[addressFound release];
	[geocoder release];
}

-(void)startDetailForViewOrEdit{
	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[UIApplication sharedApplication].delegate;

	//download sale item
	NSString *messageString = [[NSString alloc] initWithFormat:@"token=%@&command=download&id=%@",requestToken,self.saleItemId];
	DebugLog(@"request:%@", messageString);
    //NSString *encodedMessageString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)messageString, CFSTR(""), CFSTR(" %\"?=&+<>;:-"),  kCFStringEncodingUTF8);
	NSString *urlString = [[NSString alloc] initWithFormat:@"http://%@/yardsale?%@",serverHost, messageString];
	NSError *error = nil;
	InternetUtility *u = [[InternetUtility alloc] init];
	NSString *replyString = [u sendGetMethod:urlString error:error];
	[urlString release];
	[messageString release];
	[u release];
	if(error){
		[self displayWarning:NSLocalizedString(@"Could not connect to server",@"Could not connect to server")];
		return;
	}else{
		//check success
		if(replyString!=nil && [replyString rangeOfString:@"SUCCESS"].location!=NSNotFound){
			//success
			DebugLog(@"replaystring=%@",replyString);
			NSArray *components = [[replyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@"^"];
			if(components!=nil && [components count]==9){	
				NSString *itemId = [components objectAtIndex:1]; //item id
				NSString *deviceId = [components objectAtIndex:2];
				self.address.text = [components objectAtIndex:3]; //address
				self.description.text = [components objectAtIndex:4]; //desc
				self.selectedStartDate = [self dateFromString:[components objectAtIndex:5]]; //start date
				self.selectedEndDate = [self dateFromString:[components objectAtIndex:6]]; //end date
				self.startDateString.text=[components objectAtIndex:5];
				self.endDateString.text=[components objectAtIndex:6];
				//compare device id to see whether the current user has permission on this item
				if([delegate.configuration.deviceId caseInsensitiveCompare:deviceId]==0){
					//this user is the author, editing mode
					self.isEditing=YES;
					DebugLog(@"user matches record, turn on editing");
				}
			}else{
				[self displayWarning:NSLocalizedString(@"no data found",@"no data found")];
			}
		}else{
			[self displayWarning:NSLocalizedString(@"no data found",@"no data found")];
		}
		[replyString release];
	}
}

-(IBAction)doneKayboard:(id)sender{
	[sender resignFirstResponder];
}
-(IBAction)doneEditingTextArea:(id)sender{
	[self.description resignFirstResponder];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
	self.doneEditingTextArea.hidden=NO;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
	self.doneEditingTextArea.hidden=YES;
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction)delete:(id)sender{

	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[UIApplication sharedApplication].delegate;
	UIActivityIndicatorView *c = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	c.frame=CGRectMake(160, 220, 30, 30);
	[c startAnimating];
	NSString *messageString = [[NSString alloc] initWithFormat:@"token=%@&command=delete&id=%@",requestToken,self.saleItemId];
	DebugLog(@"request:%@", messageString);
    //NSString *encodedMessageString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)messageString, CFSTR(""), CFSTR(" %\"?=&+<>;:-"),  kCFStringEncodingUTF8);
	NSString *urlString = [[NSString alloc] initWithFormat:@"http://%@/yardsale?%@",serverHost, messageString];
	NSError *error = nil;
	InternetUtility *u = [[InternetUtility alloc] init];
	
	NSString *replyString = [u sendGetMethod:urlString error:error];
	[urlString release];
	[messageString release];
	[u release];
	if(error){
		//could not log on, alert
		[self displayWarning:NSLocalizedString(@"Could not connect to server",@"Could not connect to server")];
	}else{
		//
		if(replyString!=nil && [replyString rangeOfString:@"SUCCESS"].location!=NSNotFound){
			//success
			//[self displayWarning:NSLocalizedString(@"Yard Sale removed from server",@"Yard Sale removed from server")];
		}else{
			//wrong
			[self displayWarning:NSLocalizedString(@"Server was too busy or down",@"Server was too busy or down")];
		}
		[replyString release];
	}
	//
	[c stopAnimating];
	[c release];
	[self.listController refreshItemList];
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)done:(id)sender{
	//check to make sure street address, start date, and end date are populated
	if(self.address.text==nil || [self.address.text length]==0){
		[self displayWarning:NSLocalizedString(@"Please enter the street address",@"Please enter the street address")];
		return;
	}
	if(self.selectedStartDate==nil){
		[self displayWarning:NSLocalizedString(@"Please enter the sale start date",@"Please enter the sale start date")];
		return;
	}
	if(self.selectedEndDate==nil){
		[self displayWarning:NSLocalizedString(@"Please enter the sale end date",@"Please enter the sale end date")];
		return;
	}

	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[UIApplication sharedApplication].delegate;
	UIActivityIndicatorView *c = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	c.frame=CGRectMake(160, 220, 30, 30);
	[c startAnimating];
	//send to server
	NSString *deviceId = delegate.configuration.deviceId;
	NSString *addressString = self.address.text;
	NSString *desc = self.description.text;
	//format date string
	NSString *startDate = [self stringFromDate:self.selectedStartDate];
	NSString *endDate = [self stringFromDate:self.selectedEndDate];
	//
	NSString *latitudeString = [[NSString alloc]initWithFormat:@"%.6f",delegate.currentLocation.coordinate.latitude];
	NSString *longitudeString = [[NSString alloc]initWithFormat:@"%.6f",delegate.currentLocation.coordinate.longitude];
	NSString *messageString = [[NSString alloc] initWithFormat:@"token=%@&command=upload&id=%@&userId=%@&latitude=%@&longitude=%@&address=%@&description=%@&startDate=%@&endDate=%@",requestToken,self.saleItemId,deviceId,latitudeString,longitudeString,addressString,desc,startDate,endDate];
	DebugLog(@"request:%@", messageString);
    //NSString *encodedMessageString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)messageString, CFSTR(""), CFSTR(" %\"?=&+<>;:-"),  kCFStringEncodingUTF8);
	NSString *urlString = [[NSString alloc] initWithFormat:@"http://%@/serve?%@",serverHost, messageString];
	NSError *error = nil;
	InternetUtility *u = [[InternetUtility alloc] init];

	NSString *replyString = [u sendGetMethod:urlString error:error];
	[urlString release];
	[messageString release];
	[latitudeString release];
	[longitudeString release];
	[u release];
	if(error){
		//could not log on, alert
		[self displayWarning:NSLocalizedString(@"Could not connect to server",@"Could not connect to server")];
	}else{
		//
		if(replyString!=nil && [replyString rangeOfString:@"SUCCESS"].location!=NSNotFound){
			//success
			//[self displayWarning:NSLocalizedString(@"Yard Sale resistered on server",@"Yard Sale resistered on server")];
		}else{
			//wrong
			[self displayWarning:NSLocalizedString(@"Server was too busy or down",@"Server was too busy or down")];
		}
		[replyString release];
	}
	//
	[c stopAnimating];
	[c release];
	//call parent to reload
	[self.listController refreshItemList];
	[self.navigationController popViewControllerAnimated:YES];
}

-(NSString*)stringFromDate:(NSDate*)date{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
//	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	return [dateFormatter stringFromDate:date];
}

-(NSDate*)dateFromString:(NSString*)dateString{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
//	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	return [dateFormatter dateFromString:dateString];
}

-(void)displayWarning:(NSString*)msg{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
														message:msg
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Close",@"Close")
											  otherButtonTitles:nil,nil];
	alertView.opaque=YES;
	[alertView show];
	[alertView release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)showDatePicker:(id)sender{
	DebugLog(@"touch the input label!");
	InputLabel *label = (InputLabel*)sender;
	//animate a DatePicker
	if(self.datePicker==nil){
		DatePickerView *d = [[DatePickerView alloc] initWithFrame:CGRectMake(0, 500, 320, 300) AndDate:nil];
		self.datePicker=d;
		[d release];
		[self.datePicker.doneButton addTarget:self action:@selector(donePickDate:) forControlEvents:UIControlEventTouchUpInside];
		
	}

	self.datePicker.tag=label.tag;
	
	//animate up
	[self.view addSubview:self.datePicker];
	[ UIView beginAnimations: nil context: nil ]; // Tell UIView we're ready to start animations.
	[ UIView setAnimationCurve: UIViewAnimationCurveEaseInOut ];
	[ UIView setAnimationDuration: 1.0f ]; // Set the duration to 1 second.
	CGRect f2 = self.datePicker.frame;
	f2.origin.y=90;
	self.datePicker.frame=f2;
	[UIView commitAnimations];
}

-(void)donePickDate:(id)sender{
	//animate down
	[ UIView beginAnimations: nil context: nil ]; // Tell UIView we're ready to start animations.
	[ UIView setAnimationCurve: UIViewAnimationCurveEaseInOut ];
	[ UIView setAnimationDuration: 1.0f ]; // Set the duration to 1 second.
	[ UIView setAnimationDidStopSelector:@selector(removePickerView:)];
	CGRect f2 = self.datePicker.frame;
	f2.origin.y=490;
	self.datePicker.frame=f2;
	[UIView commitAnimations];
	
	
	if(self.datePicker.tag==TAG_START_DATE){
		self.selectedStartDate = self.datePicker.datePicker.date;
		self.startDateString.text=[self stringFromDate:self.selectedStartDate];
	}else{
		self.selectedEndDate = self.datePicker.datePicker.date;
		self.endDateString.text=[self stringFromDate:self.selectedEndDate];
	}
}

- (void)removePickerView:(NSString *)animationID finished:(BOOL)finished context:(void *)context{
	[self.datePicker removeFromSuperview];
}

- (void)dealloc {
	if(self.deleteButton!=nil){
		[self.deleteButton release];
	}
	if(self.saleItemId!=nil){
		[self.saleItemId release];
	}
	[doneEditingTextArea release];
	[startDateString release];
	[endDateString release];
	[address release];
	[description release];
	if(self.datePicker!=nil){
		[self.datePicker release];
	}
	[self.selectedStartDate release];
	[self.selectedEndDate release];
    [super dealloc];
}


@end
