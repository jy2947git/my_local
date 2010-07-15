//
//  LocalAdsBarControler.h
//  mylocal
//
//  Created by Junqiang You on 6/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocation;
@interface LocalAdsBarController : UIViewController {
	NSMutableDictionary *ads;
	CLLocation *currentLocation;
	UILabel *adsLabel;
}
@property(nonatomic, retain) CLLocation *currentLocation;
@property(nonatomic, retain) NSMutableDictionary *ads;
@property(nonatomic, retain) UILabel *adsLabel;
-(void)activateAdsBar:(CLLocation*)myLocation;
-(void)downloadAdsForLocation:(CLLocation*)location To:(NSMutableDictionary*)adsArray;
-(void)reportAdsDisplayData;
-(void)animateMessageToLeftBorder:(NSString*)message;
-(void)animateMessageOutOfLeftBorder:(NSString*)message;
-(NSString*)sendGetMethod:(NSString*)urlString error:(NSError *)error;
@end
