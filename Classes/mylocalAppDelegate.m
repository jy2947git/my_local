//
//  mylocalAppDelegate.m
//  mylocal
//
//  Created by Junqiang You on 5/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "mylocalAppDelegate.h"
#import "LocalItemsTableViewController.h"
#import "GlobalConfiguration.h"
#import "MapViewController.h"
#import "CoreLocation/CLLocation.h"
#import "InternetUtility.h"
#import "LocalAdsBarController.h"

@implementation mylocalAppDelegate

@synthesize window;
@synthesize vcLocalItems;
@synthesize navController;
@synthesize currentLocation;
@synthesize configuration;
@synthesize controllerTabBar;
@synthesize controllerMap;
@synthesize items;
@synthesize currentLocationAddress;
@synthesize adsBar;


- (void)applicationDidFinishLaunching:(UIApplication *)application {

	
	NSMutableArray *a = [[NSMutableArray alloc] init];
	self.items = a;
	[a release];
	
	GlobalConfiguration *g = [[GlobalConfiguration alloc]init];
	self.configuration=g;
	[g release];
	

	
    // Override point for customization after application launch
	
	//set up normal view
	
	[self startView];
	[window makeKeyAndVisible];
	
	[self startUpdateLocation];


}

-(void)startView{
	LocalItemsTableViewController *v = [[LocalItemsTableViewController alloc] initWithStyle:UITableViewStylePlain];
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
	
	LocalAdsBarController *ads = [[LocalAdsBarController alloc] init];
	self.adsBar=ads;
	[ads release];
	[window addSubview:self.adsBar.view];
}

-(void)startUpdateLocation{
	//[self startSpinner];
	//isCurrentlyUpdating = YES;
	
	//[NSThread detachNewThreadSelector:@selector(downloadBasedOnCurrentLocation) toTarget:self withObject:nil];
	
	[MyCLController sharedInstance].delegate = self;
    // Check to see if the user has disabled location services all together
    if ( ! [MyCLController sharedInstance].locationManager.locationServicesEnabled ) {
        //[self addTextToLog:NSLocalizedString(@"NoLocationServices", @"User disabled location services")];
		DebugLog(@"no location service!!");
    }
	[[MyCLController sharedInstance].locationManager startUpdatingLocation];
	
}



-(void)newLocationUpdateWithLocation:(CLLocation *)location{
	self.currentLocation=location;
	DebugLog(@"location updated");
	[[MyCLController sharedInstance].locationManager stopUpdatingLocation];

	//
	if(self.items==nil || [self.items count]==0){
		//download items and reload table
		[self.vcLocalItems refreshItemList];
	}

	//start ads bar
	[self.adsBar activateAdsBar:location];
}

-(void)newError:(NSString *)text{
	DebugLog(@"%@", text);
}

-(void)newLocationUpdateWithText:(NSString *)text{
	DebugLog(@"%@",text);
}






- (void)dealloc {

	[adsBar release];
	[currentLocationAddress release];
		[items release];
	[controllerMap release];
	[controllerTabBar release];
	[configuration release];
	[currentLocation release];	
	[vcLocalItems release];
	[navController release];
    [window release];
    [super dealloc];
}


@end
