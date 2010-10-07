//
//  Created by Björn Sållarp on 2010-03-13.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//


#import <Foundation/Foundation.h>
#import "BSGoogleV2KmlParser.h"
#import "BSGoogleV3KmlParser.h"

// Enum for geocoding status responses
enum {
	G_GEO_SUCCESS = 200,
	G_GEO_BAD_REQUEST = 400,
	G_GEO_SERVER_ERROR = 500,
	G_GEO_MISSING_QUERY = 601,
	G_GEO_UNKNOWN_ADDRESS = 602,
	G_GEO_UNAVAILABLE_ADDRESS = 603,
	G_GEO_UNKNOWN_DIRECTIONS = 604,
	G_GEO_BAD_KEY = 610,
	G_GEO_TOO_MANY_QUERIES = 620	
};

@protocol BSForwardGeocoderDelegate<NSObject>
@required
-(void)forwardGeocoderFoundLocation:(NSDictionary*)result;
@optional
-(void)forwardGeocoderError:(NSString *)errorMessage;
@end

@interface BSForwardGeocoder : NSObject <BSForwardGeocoderDelegate>{
	NSString *googleAPiKey;
	id delegate;
}
- (id) initWithDelegate:(id<BSForwardGeocoderDelegate, NSObject>)del;
//to forward geocode asynchronously
- (void) findLocationInBackground:(NSString *)searchString;
//to forward geocode synchronously
- (NSDictionary *)forwardGeocode:(NSString*)searchString error:(NSError **)error;
@property (assign) id delegate;

@end
