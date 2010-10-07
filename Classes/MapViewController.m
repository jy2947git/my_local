#import "MapViewController.h"
#import "LocationPlaceMark.h"
#import "mylocalAppDelegate.h"
#import "SalesDownloader.h"
#import "Sale.h"

@implementation MapViewController

@synthesize entries;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		NSMutableArray *a = [[NSMutableArray alloc] init];
		self.entries = a;
		[a release];
    }
    return self;
}


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	 
	 [super viewDidLoad];
	 [self.entries removeAllObjects];
	 [self.entries addObjectsFromArray:[SalesDownloader sharedInstance].items];
	 mapView=[[MKMapView alloc] initWithFrame:self.view.frame];
	 //mapView.showsUserLocation=TRUE;
	 mapView.delegate=self;

	 [self setCenterLocation:[[SalesDownloader sharedInstance] currentLocation]];
	 [self.view insertSubview:mapView atIndex:0];
	 
 }

- (void)viewDidUnload{
	
	[super viewDidUnload];
}



-(void)viewWillAppear:(BOOL)animated{
		
	NSMutableArray *otherLocations = [[NSMutableArray alloc] init];
	for(Sale *sale in entries){
		
			//create location-place-mark
			CLLocationCoordinate2D c = {[sale.latitude doubleValue],[sale.longitude doubleValue]};
		LocationPlaceMark *m = [[LocationPlaceMark alloc]initWithCoordinate:c title:[NSString stringWithFormat:@"%@",sale.address1] subtitle:nil];
			[otherLocations addObject:m];
			[m release];
		
	}
	[self setOtherLocations:otherLocations];
}

-(void)setCenterLocation:(CLLocation*)myLocation{
	
	LocationPlaceMark *me = [[LocationPlaceMark alloc]initWithCoordinate:myLocation.coordinate title:@"me" subtitle:NSLocalizedString(@"You are here",@"You are here")];
	
	MKCoordinateRegion region;
	region.center=myLocation.coordinate;
	//Set Zoom level using Span
	MKCoordinateSpan span;
	span.latitudeDelta=.05;
	span.longitudeDelta=.05;
	region.span=span;
	
	[mapView setRegion:region animated:TRUE];
	//anotation
	[mapView addAnnotation:me];
	[me release];
}


-(void)setOtherLocations:(NSArray*)otherLocations{
	for(int i=0;i<[otherLocations count];i++){
		[mapView addAnnotation:[otherLocations objectAtIndex:i]];
	}
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



- (void)dealloc {
	[entries release];
    [super dealloc];
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
	DebugLog(@"failed to look up location");
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	NSLog(@"Geocoder completed");
//	mPlacemark=placemark;
	[mapView addAnnotation:placemark];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
	NSLog(@"View for Annotation is called");
	MKPinAnnotationView *test=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingloc"];
	//MKAnnotationView *test=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingloc"];
	//test.userInteractionEnabled=TRUE;
	if([annotation title]==@"me")
	{
		DebugLog(@"mark my center location");
		[test setPinColor:MKPinAnnotationColorPurple];
	}
	else
	{
		DebugLog(@"mark other location");
		[test setPinColor:MKPinAnnotationColorRed];
		UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 30, 20)];
		t.text=annotation.title;
		t.backgroundColor=[UIColor clearColor];
		t.font=[UIFont systemFontOfSize:12];
		t.textColor=[UIColor redColor];
		[test addSubview:t];
		[t release];
	}

	//test.image=[UIImage imageNamed:@"table-cell-number.png"];
	//test.animatesDrop=YES;
	return test;
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
//	mStoreLocationButton.hidden=FALSE;
//	location=newLocation.coordinate;
//	//One location is obtained.. just zoom to that location
//	
//	MKCoordinateRegion region;
//	region.center=location;
//	//Set Zoom level using Span
//	MKCoordinateSpan span;
//	span.latitudeDelta=.005;
//	span.longitudeDelta=.005;
//	region.span=span;
//	
//	[mapView setRegion:region animated:TRUE];
//
//}

//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//}

-(void)lookupAddress:(CLLocationCoordinate2D)location{

	MKReverseGeocoder *geocoder=[[MKReverseGeocoder alloc] initWithCoordinate:location];
	geocoder.delegate=self;
	[geocoder start];
	

}


@end
