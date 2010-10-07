//
//  Created by Björn Sållarp on 2010-03-13.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "BSForwardGeocoder.h"


@implementation BSForwardGeocoder

@synthesize delegate;

- (id)init{
	if( self = [super init] ){
	}

	return self;
}

-(id) initWithDelegate:(id<BSForwardGeocoderDelegate>)del
{

	if (self = [super init]) {
		if (del) {
			delegate = del;
		}else {
			delegate = self;
		}

		
	}
	return self;
}

-(void) findLocationInBackground:(NSString *)searchString
{
	[self performSelectorInBackground:@selector(startGeocoding:) withObject:searchString];
}


- (NSDictionary *)forwardGeocode:(NSString*)searchString error:(NSError **)error{
	int version = 3;
	if (searchString==nil || [searchString isEqualToString:@""]) {
		return nil;
	}
	NSError *parseError = nil;
	
	
	if(version == 2)
	{
		// Create the url to Googles geocoding API, we want the response to be in XML
		
		NSString* mapsUrl = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps/geo?q=%@&gl=se&output=xml&oe=utf8&sensor=false", 
							 searchString];
		
		// Create the url object for our request. It's important to escape the 
		// search string to support spaces and international characters
		NSURL *url = [[NSURL alloc] initWithString:[mapsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		// Run the KML parser
		BSGoogleV2KmlParser *parser = [[BSGoogleV2KmlParser alloc] init];
		
		[parser parseXMLFileAtURL:url parseError:&parseError];
		
		[url release];
		[mapsUrl release];
		
		
		// If the query was successfull we store the array with results
		if(parser.statusCode == G_GEO_SUCCESS)
		{
			NSDictionary *result = [NSDictionary dictionaryWithObject:parser.placemarks forKey:searchString];
			return result;
		}else {
			NSLog(@"geocode unsuccessful status %d", parser.statusCode);
		}
	
		
		[parser release];
		
	}
	else if(version == 3)
	{
		// Create the url to Googles geocoding API, we want the response to be in XML
		NSString* mapsUrl = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps/api/geocode/xml?address=%@&sensor=false", 
							 searchString];
		
		// Create the url object for our request. It's important to escape the 
		// search string to support spaces and international characters
		NSURL *url = [[NSURL alloc] initWithString:[mapsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSLog(@"%@", url);
		// Run the KML parser
		BSGoogleV3KmlParser *parser = [[BSGoogleV3KmlParser alloc] init];
		
		[parser parseXMLFileAtURL:url parseError:&parseError ignoreAddressComponents:NO];
		if (parseError) {
			NSLog(@"Geocoder parse error %@", [parseError localizedDescription]);
		}
		[url release];
		[mapsUrl release];
		
		
		// If the query was successfull we store the array with results
		if(parser.statusCode == G_GEO_SUCCESS)
		{
			NSDictionary *result = [NSDictionary dictionaryWithObject:parser.results forKey:searchString];
			
			return result;
		}else {
			NSLog(@"geocode unsuccessful status %d", parser.statusCode);
		}
	
		
		[parser release];
	}
	
	
	
	if(parseError != nil)
	{
		*error  = parseError;
		return nil;
	}
	return nil;
}

-(void)startGeocoding:(NSString*)searchString
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (searchString==nil || [searchString isEqualToString:@""]) {
		return;
	}
	int version = 3;
	
	NSError *parseError = nil;
	
	
	if(version == 2)
	{
		// Create the url to Googles geocoding API, we want the response to be in XML
		
		NSString* mapsUrl = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps/geo?q=%@&gl=se&output=xml&oe=utf8&sensor=false", 
							 searchString];
		
		// Create the url object for our request. It's important to escape the 
		// search string to support spaces and international characters
		NSURL *url = [[NSURL alloc] initWithString:[mapsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		// Run the KML parser
		BSGoogleV2KmlParser *parser = [[BSGoogleV2KmlParser alloc] init];
		
		[parser parseXMLFileAtURL:url parseError:&parseError];
		
		[url release];
		[mapsUrl release];
		
		
		// If the query was successfull we store the array with results
		if(parser.statusCode == G_GEO_SUCCESS)
		{
			NSDictionary *result = [NSDictionary dictionaryWithObject:parser.placemarks forKey:searchString];
			if([delegate respondsToSelector:@selector(forwardGeocoderFoundLocation:)])
			{
				[delegate performSelectorOnMainThread:@selector(forwardGeocoderFoundLocation:) withObject:result waitUntilDone:NO];
			}
		}
		
		[parser release];
		
	}
	else if(version == 3)
	{
		// Create the url to Googles geocoding API, we want the response to be in XML
		NSString* mapsUrl = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps/api/geocode/xml?address=%@&sensor=false", 
							 searchString];
		
		// Create the url object for our request. It's important to escape the 
		// search string to support spaces and international characters
		NSURL *url = [[NSURL alloc] initWithString:[mapsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSLog(@"%@", url);
		// Run the KML parser
		BSGoogleV3KmlParser *parser = [[BSGoogleV3KmlParser alloc] init];
		
		[parser parseXMLFileAtURL:url parseError:&parseError ignoreAddressComponents:NO];
		if (parseError) {
			NSLog(@"Geocoder parse error %@", [parseError localizedDescription]);
		}
		[url release];
		[mapsUrl release];
		
		
		// If the query was successfull we store the array with results
		if(parser.statusCode == G_GEO_SUCCESS)
		{
			NSDictionary *result = [NSDictionary dictionaryWithObject:parser.results forKey:searchString];

			if([delegate respondsToSelector:@selector(forwardGeocoderFoundLocation:)])
			{
				[delegate performSelectorOnMainThread:@selector(forwardGeocoderFoundLocation:) withObject:result waitUntilDone:NO];
			}
		}else {
			NSLog(@"geocode unsuccessful status %d", parser.statusCode);
		}

		
		[parser release];
	}
	
	
	
	if(parseError != nil)
	{
		if([delegate respondsToSelector:@selector(forwardGeocoderError:)])
		{
			[delegate performSelectorOnMainThread:@selector(forwardGeocoderError:) withObject:[parseError localizedDescription] waitUntilDone:NO];
		}
	}
	
	
	
	[pool release];
	
	
	
}

#pragma mark Default implementation of delegate
-(void)forwardGeocoderError:(NSString *)errorMessage
{
	NSLog(@"Failed to geocode %@", errorMessage);
	
}

-(void)forwardGeocoderFoundLocation:(NSDictionary*)result
{
	
//	NSLog(@"found address for %@", [[result allKeys] lastObject]);
	NSArray* results = [result allValues];
	for (BSKmlResult *result in results){
		NSLog(@"%f %f", result.latitude, result.longitude);
	}
	
}


-(void)dealloc
{
	[googleAPiKey release];
	
	[super dealloc];
}


@end
