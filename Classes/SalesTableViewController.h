//
//  SalesTableViewController.h
//  mylocal
//
//  Created by You, Jerry on 10/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCLController.h"
#import "UrlDownloaderOperation.h"
// Shorthand for getting localized strings, used in formats below for readability
#define LocStr(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]


@class SalesTableViewCell;
@class DownloaderQueue;
@interface SalesTableViewController : UITableViewController <MyCLControllerDelegate, UrlDownloaderOperationDelegate>{
	NSMutableArray *entries;
	NSMutableDictionary *imageDownloadsInProgress;
	//to controll the customized table-view-cell
	SalesTableViewCell *saleCell;
	DownloaderQueue *queue;
	CLLocation *lastQueryLocation;
	CLLocation *currentLocation;
	NSTimer *refreshSalesTimer;
}
@property (nonatomic, retain) DownloaderQueue *queue;
@property (nonatomic, retain) IBOutlet SalesTableViewCell *saleCell;
@property (nonatomic, retain) NSMutableArray *entries;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) CLLocation *lastQueryLocation;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSTimer *refreshSalesTimer;
-(void)addButtonWasPressed;
//-(void)displayWarning:(NSString*)msg;
@end
