//
//  LocalItemsTableViewController.h
//  mylocal
//
//  Created by Junqiang You on 5/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoreLocation/CLLocation.h"
@class InternetUtility;

// Shorthand for getting localized strings, used in formats below for readability
#define LocStr(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]
@interface LocalItemsTableViewController : UITableViewController{
		UIActivityIndicatorView *spinner;
}


@property(nonatomic, retain) UIActivityIndicatorView *spinner;


-(void)startSpinner;
-(void)stopSpinner;
-(void)addButtonWasPressed;
-(void)refreshItemList;
-(void)displayWarning:(NSString*)msg;
NSInteger sortItemsByDistanceFromMe(id data1, id data2, void *context);
CLLocationDistance findDistanceFromMe(NSString* latitude, NSString* longitude);


@end
