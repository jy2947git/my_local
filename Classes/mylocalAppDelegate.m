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
#import "LocalAdsBarController.h"
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
@synthesize adsBar;


- (void)applicationDidFinishLaunching:(UIApplication *)application {

	
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
	
	LocalAdsBarController *ads = [[LocalAdsBarController alloc] init];
	self.adsBar=ads;
	[ads release];
	[window addSubview:self.adsBar.view];
}







- (void)dealloc {

	[adsBar release];
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


@end
