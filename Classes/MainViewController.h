
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController <MKMapViewDelegate, MKReverseGeocoderDelegate, CLLocationManagerDelegate> {
	MKMapView *mapView;
	MKPlacemark *mPlacemark;
	CLLocationCoordinate2D location;
	IBOutlet UIButton *mStoreLocationButton;
	
}

- (IBAction)storeLocationInfo:(id) sender;

@end
