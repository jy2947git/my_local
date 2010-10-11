//
//  mylocalAppDelegate.h
//  mylocal
//
//  Created by Junqiang You on 5/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SalesTableViewController;

@class GlobalConfiguration;
@class MapViewController;
@class LocalAdsBarController;
@interface mylocalAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *controllerTabBar;
	UINavigationController *navController;
	MapViewController *controllerMap;
	SalesTableViewController *vcLocalItems;

	GlobalConfiguration *configuration;
	
		NSMutableArray *items;
	NSString *currentLocationAddress;
	
	LocalAdsBarController *adsBar;
	//
	//we are using CoreData framework to store Sale locally to minimize
	//the server hit.
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

@property(nonatomic, retain) LocalAdsBarController *adsBar;
@property(nonatomic, retain) NSString *currentLocationAddress;
@property(nonatomic, retain) NSMutableArray *items;
@property(nonatomic, retain) MapViewController *controllerMap;
@property(nonatomic, retain) UITabBarController *controllerTabBar;
@property(nonatomic, retain) GlobalConfiguration *configuration;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) SalesTableViewController *vcLocalItems;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
-(void)startView;
//-(int)showBillboardTemporaryMessage:(NSString *)msg;



- (NSString *)applicationDocumentsDirectory;
- (void)saveContext;

@end

