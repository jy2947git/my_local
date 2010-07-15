
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
#import <CoreLocation/CoreLocation.h>
@class LocationPlaceMark;
@interface MapViewController : UIViewController <MKMapViewDelegate, MKReverseGeocoderDelegate, CLLocationManagerDelegate> {
	MKMapView *mapView;
//	MKPlacemark *mPlacemark;

	
}

-(void)setCenterLocation:(LocationPlaceMark*)myLocation;
-(void)setOtherLocations:(NSArray*)otherLocations;
-(void)lookupAddress:(CLLocationCoordinate2D)location;
@end
