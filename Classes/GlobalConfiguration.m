//
//  GlobalConfiguration.m
//  iSpeak
//
//  Created by Junqiang You on 5/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GlobalConfiguration.h"



@implementation GlobalConfiguration

@synthesize appPrivilege;

@synthesize deviceId;
@synthesize osVersion;
- (id)init{
	if((self=[super init])!=nil){
		self.osVersion = [[UIDevice currentDevice] systemVersion];
		self.deviceId = [[UIDevice currentDevice] uniqueIdentifier];
						
	}
	
	return self;
}

-(void)saveToFile{
	NSMutableArray *keys = [[NSMutableArray alloc] init];
	NSMutableArray *objects = [[NSMutableArray alloc]init];
	

	
	NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	[dictionary writeToFile:[documentDirectory stringByAppendingPathComponent:@"mylocal.setting"] atomically:YES];
	[objects release];
	[keys release];
	[dictionary release];
}

-(BOOL)isOS3{
	return [self.osVersion hasPrefix:@"3."];
}

-(NSString*)encodeDeviceSpecificString:(NSString*)inputString{
	NSUInteger deviceNumber = [self.deviceId hash];
	NSString *s = [NSString stringWithFormat:@"%i%@",deviceNumber, inputString];
	DebugLog(@"input:%@ device-UID:%@ device-hash:%i final:%@",inputString, self.deviceId, deviceNumber, s);
	return s;
}


-(NSString*)decodeDeviceSpecificString:(NSString*)encodedString{
	NSUInteger deviceNumber = [self.deviceId hash];
	NSString *d = [[NSString alloc] initWithFormat:@"%i",deviceNumber];
	NSString *result;
	if([encodedString hasPrefix:d]){
		//yes
		result = [encodedString substringFromIndex:[d length]];
	}else{
		result = nil;
	}
	DebugLog(@"encoded:%@ device-UID:%@ device-id:%i decoded:%@",encodedString, self.deviceId, deviceNumber, result);
	[d release];
	return result;
}
- (void)dealloc {

	[osVersion release];
	[deviceId release];		
	[super dealloc];
}
@end
