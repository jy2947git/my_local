#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface LocationPlaceMark : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
}
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate title:(NSString*)title subtitle:(NSString*)subtitle;


@end
