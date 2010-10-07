
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
#import <CoreLocation/CoreLocation.h>
@class LocationPlaceMark;
@interface MapViewController : UIViewController <MKMapViewDelegate, MKReverseGeocoderDelegate, CLLocationManagerDelegate> {
	MKMapView *mapView;

	NSMutableArray *entries;
}
@property (nonatomic, retain) NSMutableArray *entries;

-(void)setCenterLocation:(CLLocation*)myLocation;
-(void)setOtherLocations:(NSArray*)otherLocations;
-(void)lookupAddress:(CLLocationCoordinate2D)location;
@end
