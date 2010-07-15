#import "LocationPlaceMark.h"

@implementation LocationPlaceMark
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString*)t  subtitle:(NSString*)s{
	self.coordinate=c;
	self.title=t;
	self.subtitle=s;
	return self;
}

- (void)dealloc {
	[self.title release];
	[self.subtitle release];
	[super dealloc];
}
@end
