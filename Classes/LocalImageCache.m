//
//  LocalImageCache.m
//  mylocal
//
//  Created by You, Jerry on 10/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocalImageCache.h"
#import "mylocalAppDelegate.h"
#import "CorePhoto.h"

@implementation LocalImageCache


- (void)dealloc{
	[super dealloc];
}

+ (void)saveImage:(UIImage*)data withKey:(NSString*)key{
	DebugLog(@"Saving image to local cache with key:%@", key);
	//create a CorePhoto object and save to object-store
	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = delegate.managedObjectContext;
	CorePhoto *photo = [NSEntityDescription insertNewObjectForEntityForName:@"CorePhoto" inManagedObjectContext:context];
	photo.blobKey=key;
	photo.image=data;
	NSError *error = nil;
	if (![context save:&error]) {
		// Handle the error.
		DebugLog(@"Failed to save CorePhoto %@", [error localizedDescription]);
	}
	
}
+ (UIImage*)getImageFromKey:(NSString*)key{
	DebugLog(@"Checking image from local cache with key:%@", key);
	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = delegate.managedObjectContext;
	//fetch the core-data with key
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDesc = [NSEntityDescription    
									   entityForName:@"CorePhoto" inManagedObjectContext:context];
	[request setEntity:entityDesc];
	
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"(blobKey = %@)", key];
	
	[request setPredicate:pred];
	
	NSError *error=nil;
	
	NSArray *matching_objects = [context executeFetchRequest:request error:&error]; 
	[request release];
	if (error) {
		DebugLog(@"Failed to query CorePhoto %@", [error localizedDescription]);
		return nil;
	}else {
		if ([matching_objects count]>0) {
			DebugLog(@"Found!");
			CorePhoto *photo = [matching_objects objectAtIndex:0];
			return photo.image;
		}
		return nil;
	}

}
@end
