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
#import "CoreEvent.h"

@implementation LocalImageCache


- (void)dealloc{
	[super dealloc];
}

+ (CorePhoto*)saveImage:(UIImage*)data withKey:(NSString*)key{
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
	return photo;
	
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

+ (CorePhoto*)createPhotoWithThumbNailImage:(UIImage*)thumbNail image:(UIImage*)img{
	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = delegate.managedObjectContext;
	CorePhoto *photo = [NSEntityDescription insertNewObjectForEntityForName:@"CorePhoto" inManagedObjectContext:context];
	photo.blobKey=@"full-image"; //key does not matter in the local-photo case
	photo.thumbNailBlobKey=@"icon-image";
	photo.image=img;
	photo.thumbNailImage=thumbNail;
	NSError *error = nil;
	if (![context save:&error]) {
		// Handle the error.
		DebugLog(@"Failed to save CorePhoto %@", [error localizedDescription]);
	}
	return photo;
}

+ (CoreEvent*)getCurrentEditingEvent{
	CoreEvent *event = [self getPendingEvent];
	if (!event) {
		DebugLog(@"creating new event ...");
		//create a new one, save it and return it
		mylocalAppDelegate *delegate = (mylocalAppDelegate*)[[UIApplication sharedApplication] delegate];
		NSManagedObjectContext *context = delegate.managedObjectContext;
		event = [NSEntityDescription insertNewObjectForEntityForName:@"CoreEvent" inManagedObjectContext:context];
		NSError *error = nil;
		if (![context save:&error]) {
			// Handle the error.
			NSLog(@"Failed to save CoreEvent %@", [error localizedDescription]);
		}else {
			DebugLog(@"event is saved");
		}

	}
	return event;
}

+ (void)saveDoneEvent:(CoreEvent*)event{
	event.status=@"valid";
	[self saveEvent:event];
}

+ (void)saveEvent:(CoreEvent*)event{
	DebugLog(@"try to save Event %@ %@", event.location, event.summary);
	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = delegate.managedObjectContext;
	if ([event isUpdated]) {
		DebugLog(@"event is updated, saving to store now...");
		//save
		NSError *error = nil;
		if (![context save:&error]) {
			// Handle the error.
			DebugLog(@"Failed to save CoreEvent %@", [error localizedDescription]);
		}else {
			DebugLog(@"event is saved");
		}
		
	}
}

+ (CoreEvent*)getPendingEvent{
	mylocalAppDelegate *delegate = (mylocalAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = delegate.managedObjectContext;
	//fetch the core-data with key
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDesc = [NSEntityDescription    
									   entityForName:@"CoreEvent" inManagedObjectContext:context];
	[request setEntity:entityDesc];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"(status = \"pending\")"];
	
	[request setPredicate:pred];
	NSError *error=nil;
	
	NSArray *matching_objects = [context executeFetchRequest:request error:&error]; 
	[request release];
	if (error) {
		DebugLog(@"Failed to query CoreEvent %@", [error localizedDescription]);
		return nil;
	}else {
		DebugLog(@"found %i events", [matching_objects count]);
		if ([matching_objects count]>0) {
			
			CoreEvent *event = [matching_objects objectAtIndex:0];
			DebugLog(@"Found! %@ %@", event.location, event.summary);
			return event;
		}
		return nil;
	}
}
@end
