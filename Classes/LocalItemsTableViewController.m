//
//  LocalItemsTableViewController.m
//  mylocal
//
//  Created by Junqiang You on 5/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LocalItemsTableViewController.h"
#import "GlobalHeader.h"
#import "LocalItemDetailViewController.h"
#import "InternetUtility.h"
#import "mylocalAppDelegate.h"
#import "SaleItemCell.h"
#define MetersOfOneMile 1609.344

@implementation LocalItemsTableViewController
@synthesize spinner;
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		self.title=NSLocalizedString(@"Search",@"Search");
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *a = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonWasPressed)];
	self.navigationItem.rightBarButtonItem = a;
	[a release];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.tableView.rowHeight=65;

//	[self startUpdateLocation];
	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[UIApplication sharedApplication].delegate;
//	[delegate showBillboardTemporaryMessage:@"Welcome!!"];
	[self startSpinner];
	if(delegate.currentLocation!=nil){
		[self refreshItemList];
	}else{
		DebugLog(@"bad timing....location is not updated yet");
	}
	//[self stopSpinner];
}

-(void)viewWillAppear:(BOOL)animated{

}




-(void)refreshItemList{
	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[UIApplication sharedApplication].delegate;
	//search from server
	[self startSpinner];
	
	NSString *latitudeString = [[NSString alloc]initWithFormat:@"%.6f",delegate.currentLocation.coordinate.latitude];
	NSString *longitudeString = [[NSString alloc]initWithFormat:@"%.6f",delegate.currentLocation.coordinate.longitude];
	NSString *messageString = [[NSString alloc] initWithFormat:@"token=%@&command=browse&start=0&end=100&latitude=%@&longitude=%@",requestToken,latitudeString,longitudeString];
	DebugLog(@"request:%@", messageString);
    //NSString *encodedMessageString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)messageString, CFSTR(""), CFSTR(" %\"?=&+<>;:-"),  kCFStringEncodingUTF8);
	NSString *urlString = [[NSString alloc] initWithFormat:@"http://%@/yardsale?%@",serverHost, messageString];
	NSError *error = nil;
	InternetUtility *u = [[InternetUtility alloc] init];
	NSString *replyString = [u sendGetMethod:urlString error:error];
	[urlString release];
	[messageString release];
	[latitudeString release];
	[longitudeString release];
	[u release];
	[self stopSpinner];
	if(error){
		//could not log on, alert
		[self displayWarning:NSLocalizedString(@"Could not connect to server",@"Could not connect to server")];
		return;
	}else{
		
		//success SUCCESS|id^address^desecription^startDate^endDate|id2
		if(replyString!=nil && [replyString rangeOfString:@"SUCCESS"].location!=NSNotFound){
			//success
			[delegate.items removeAllObjects];
			NSArray *components = [[replyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@"|"];
			if(components!=nil && [components count]>1){
				//there are records
				for(int i=1;i<[components count];i++){
					NSMutableString *s = [[NSMutableString alloc] initWithString:[components objectAtIndex:i]];
					//calculate distance from me, and append it
					NSArray *itemData = [s componentsSeparatedByString:@"^"];
					[s appendFormat:@"^%.2f miles",findDistanceFromMe([itemData objectAtIndex:6],[itemData objectAtIndex:7])/MetersOfOneMile];
					[delegate.items addObject:s];
					[s release];
				}
				//sort
				[delegate.items sortUsingFunction:sortItemsByDistanceFromMe context:nil];
				//
				[self.tableView reloadData];
			}else{
				DebugLog(@"no data");
				[self displayWarning:NSLocalizedString(@"No sale around you",@"No sale around you")];
			}
		}else{
			//strange
			DebugLog(@"no error, and not success either");
			[self displayWarning:NSLocalizedString(@"Server was too busy or down",@"Server was too busy or down")];
		}
		
		[replyString release];
		
	}

	
}
-(void)addButtonWasPressed{
	//animate to detail view
	LocalItemDetailViewController *anotherViewController = [[LocalItemDetailViewController alloc] initWithNibName:@"ItemDetailView" bundle:nil];
	anotherViewController.isNew=YES;
	anotherViewController.listController=self;
	[self.navigationController pushViewController:anotherViewController  animated:YES];
	[anotherViewController release];
}





NSInteger sortItemsByDistanceFromMe(id data1, id data2, void *context)
{
	NSArray *itemData1 = [data1 componentsSeparatedByString:@"^"];
	NSArray *itemData2 = [data2 componentsSeparatedByString:@"^"];
	CLLocationDistance distance1 = [[itemData1 objectAtIndex:8] doubleValue];
	CLLocationDistance distance2 = [[itemData2 objectAtIndex:8] doubleValue];

	
    if (distance1 < distance2)
        return NSOrderedAscending;
    else if (distance1 > distance2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

CLLocationDistance findDistanceFromMe(NSString* latitude, NSString* longitude){
	
	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[UIApplication sharedApplication].delegate;
	CLLocation *me = delegate.currentLocation;
	CLLocation *yardsale = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
	CLLocationDistance distanceInMeter = [me getDistanceFrom:yardsale];
	[yardsale release];
	return distanceInMeter;
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


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[UIApplication sharedApplication].delegate;
    return [delegate.items count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    mylocalAppDelegate *delegate = (mylocalAppDelegate*)[UIApplication sharedApplication].delegate;
    static NSString *CellIdentifier = @"saleItemCell";
    
    SaleItemCell *cell = (SaleItemCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SaleItemCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
 	
    // Set up the cell...
	NSMutableString *s = [delegate.items objectAtIndex:indexPath.row];
	NSArray *itemData = [s componentsSeparatedByString:@"^"];

	//sale item
//		NSString *sid = [itemData objectAtIndex:0];
//		NSString *userId = [itemData objectAtIndex:1];
	NSString *address = [itemData objectAtIndex:2];
	NSString *desc = [itemData objectAtIndex:3];
	NSString *startDate = [itemData objectAtIndex:4];
	NSString *endDate = [itemData objectAtIndex:5];
//		NSString *latitude = [itemData objectAtIndex:6];
//		NSString *longitude = [itemData objectAtIndex:7];
	NSString *distance = [itemData objectAtIndex:8];
	
	cell.myLocation=delegate.currentLocation;
	[cell setSaleItemOrder:indexPath.row Address:address description:desc distance:distance startDate:startDate endDate:endDate];
	//cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
	cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//-(NSString*)getLocationString:(CLLocation*)newLocation{
//	NSMutableString *update = [[NSMutableString alloc] init];
//	
//	// Horizontal coordinates
//	if (signbit(newLocation.horizontalAccuracy)) {
//		// Negative accuracy means an invalid or unavailable measurement
//		[update appendString:LocStr(@"LatLongUnavailable")];
//	} else {
//		// CoreLocation returns positive for North & East, negative for South & West
//		[update appendFormat:LocStr(@"LatLongFormat"), // This format takes 4 args: 2 pairs of the form coordinate + compass direction
//		 fabs(newLocation.coordinate.latitude), signbit(newLocation.coordinate.latitude) ? LocStr(@"South") : LocStr(@"North"),
//		 fabs(newLocation.coordinate.longitude),	signbit(newLocation.coordinate.longitude) ? LocStr(@"West") : LocStr(@"East")];
//		[update appendString:@"\n"];
//		[update appendFormat:LocStr(@"MeterAccuracyFormat"), newLocation.horizontalAccuracy];
//	}
//	[update appendString:@"\n\n"];
//	
//	// Altitude
//	if (signbit(newLocation.verticalAccuracy)) {
//		// Negative accuracy means an invalid or unavailable measurement
//		[update appendString:LocStr(@"AltUnavailable")];
//	} else {
//		// Positive and negative in altitude denote above & below sea level, respectively
//		[update appendFormat:LocStr(@"AltitudeFormat"), fabs(newLocation.altitude),	(signbit(newLocation.altitude)) ? LocStr(@"BelowSeaLevel") : LocStr(@"AboveSeaLevel")];
//		[update appendString:@"\n"];
//		[update appendFormat:LocStr(@"MeterAccuracyFormat"), newLocation.verticalAccuracy];
//	}
//	[update appendString:@"\n\n"];
//	
//	return update;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[UIApplication sharedApplication].delegate;
	NSString *s = [delegate.items objectAtIndex:indexPath.row];
	NSArray *itemData = [s componentsSeparatedByString:@"^"];

		//sale item
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
		NSString *sid = [itemData objectAtIndex:0];

		LocalItemDetailViewController *anotherViewController = [[LocalItemDetailViewController alloc] initWithNibName:@"ItemDetailView" bundle:nil];
		anotherViewController.saleItemId=sid;
	anotherViewController.listController=self;
		DebugLog(@"same item id = %@", anotherViewController.saleItemId);
		anotherViewController.isNew=NO;
		[self.navigationController pushViewController:anotherViewController  animated:YES];
		[anotherViewController release];

}

-(void)startSpinner{
	if(self.spinner==nil){
		DebugLog(@"creagting spinner...");
		UIActivityIndicatorView *c = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		c.frame=CGRectMake(150, 200, 30, 30);
		
		self.spinner =c;
		[c release];
		[self.view addSubview:self.spinner];
	}
	if(![self.spinner isAnimating]){
		DebugLog(@"spinning...");
		[self.spinner startAnimating];
	}
}

-(void)stopSpinner{
	if(self.spinner!=nil && [self.spinner isAnimating]){
		DebugLog(@"stoping spinning...");
		[self.spinner stopAnimating];
	}
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
 NSString *APPTOKEN=@"xxxxx";
 - (NSString*)getLocation{
 
 // Location has been found
 CLLocationCoordinate2D loc = self.location.coordinate;	
 // Contact Yahoo and make a local info request
 NSString *requestString = [NSString stringWithFormat:@"http://zonetag.research.yahooapis.com/services/rest/V1/suggestedTags.php?apptoken=%@&latitude=%f&longitude=%f&output=xml",
 APPTOKEN, // Please use your own apptoken
 loc.latitude, loc.longitude];
 NSURL *url = [NSURL URLWithString:requestString];
 NSString *string = [[[NSString stringWithContentsOfURL:url] substringFromIndex:[APPTOKEN length]] autorelease];
 return @"not yet";//[[XMLParser sharedInstance] parseXMLData:[string dataUsingEncoding:NSUTF8StringEncoding]];
 
 }
 */
- (void)dealloc {

		[spinner release];

	[super dealloc];
}


@end

