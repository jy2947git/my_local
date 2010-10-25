//
//  mylocalAppDelegate.m
//  mylocal
//
//  Created by Junqiang You on 5/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "mylocalAppDelegate.h"
#import "GlobalConfiguration.h"
#import "MapViewController.h"
#import "CoreLocation/CLLocation.h"
#import "InternetUtility.h"
#import "GTMIPhoneUnitTestDelegate.h"
#import "SalesTableViewController.h"

@implementation mylocalAppDelegate

@synthesize window;
@synthesize vcLocalItems;
@synthesize navController;

@synthesize configuration;
@synthesize controllerTabBar;
@synthesize controllerMap;
@synthesize items;
@synthesize currentLocationAddress;



- (void)applicationDidFinishLaunching:(UIApplication *)application {

	NSManagedObjectContext *context = [self managedObjectContext];
	if (!context) {
		// Handle the error.
	}
	
	NSMutableArray *a = [[NSMutableArray alloc] init];
	self.items = a;
	[a release];
	
	GlobalConfiguration *g = [[GlobalConfiguration alloc]init];
	self.configuration=g;
	[g release];
	


#if UNIT_TEST
	[window makeKeyAndVisible];
	/* Run all unit tests
	 * - All unit test output will show in the console of the debug view
	 * - Obviously, upon distribution, disable unit tests 
	 * Distro builds: set UNIT_TEST to 0 in your *.pch file (precompiled header file)
	 */
	[[GTMIPhoneUnitTestDelegate shared] applicationDidFinishLaunching:application];
#else
	[self startView];
	[window makeKeyAndVisible];
#endif


}

-(void)startView{
	SalesTableViewController *v = [[SalesTableViewController alloc] initWithStyle:UITableViewStylePlain];
	self.vcLocalItems=v;
	[v release];
	UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:self.vcLocalItems];
	self.navController=n;
	//self.navController.title=NSLocalizedString(@"Yard Sales",@"Yard Sales");
	UITabBarItem *nt=[[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"yard-sale-tab.png"] tag:1];
	self.navController.tabBarItem=nt;
	[nt release];
	[n release];
	MapViewController *m = [[MapViewController alloc] init];
	self.controllerMap=m;
	//self.controllerMap.title=NSLocalizedString(@"Map",@"Map");
	UITabBarItem *mt=[[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"map-tab.png"] tag:2];
	self.controllerMap.tabBarItem=mt;
	[mt release];
	[m release];
	UITabBarController *t = [[UITabBarController alloc] init];
	self.controllerTabBar=t;
	[t release];
	
	self.controllerTabBar.viewControllers=[[NSArray alloc] initWithObjects:self.navController,self.controllerMap,nil];
	self.controllerTabBar.selectedViewController=self.navController;
	self.controllerTabBar.selectedIndex=0;
	[window addSubview:self.controllerTabBar.view];
	//	[window addSubview:self.navController.view];
}







- (void)dealloc {
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	

	[currentLocationAddress release];
		[items release];
	[controllerMap release];
	[controllerTabBar release];
	[configuration release];

	[vcLocalItems release];
	[navController release];
    [window release];
    [super dealloc];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self saveContext];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

- (void)saveContext {
    
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"cached-sales.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	
	// Allow inferred migration from the original version of the application.
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle the error.
		NSLog(@"failed to create the persistence store %@", [error localizedDescription]);
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


@end
