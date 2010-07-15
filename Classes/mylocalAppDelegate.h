//
//  mylocalAppDelegate.h
//  mylocal
//
//  Created by Junqiang You on 5/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCLController.h"
@class LocalItemsTableViewController;
@class CLLocation;
@class GlobalConfiguration;
@class MapViewController;
@class LocalAdsBarController;
@interface mylocalAppDelegate : NSObject <UIApplicationDelegate, MyCLControllerDelegate> {
    UIWindow *window;
	UITabBarController *controllerTabBar;
	UINavigationController *navController;
	MapViewController *controllerMap;
	LocalItemsTableViewController *vcLocalItems;

	GlobalConfiguration *configuration;
	
		NSMutableArray *items;
		CLLocation *currentLocation;
	NSString *currentLocationAddress;
	
	LocalAdsBarController *adsBar;

}

@property(nonatomic, retain) LocalAdsBarController *adsBar;
@property(nonatomic, retain) NSString *currentLocationAddress;
@property(nonatomic, retain) NSMutableArray *items;
@property(nonatomic, retain) MapViewController *controllerMap;
@property(nonatomic, retain) UITabBarController *controllerTabBar;
@property(nonatomic, retain) GlobalConfiguration *configuration;
@property(nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) LocalItemsTableViewController *vcLocalItems;
-(void)startView;
//-(int)showBillboardTemporaryMessage:(NSString *)msg;
-(void)startUpdateLocation;




@end

