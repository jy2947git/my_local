//
//  LocalItemDetailViewController.h
//  mylocal
//
//  Created by Junqiang You on 5/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MKReverseGeocoder.h"

enum TAG_DATE_PICKER{
	TAG_START_DATE=98387,
	TAG_END_DATE=98388
};
@class CLLocation;
@class InputLabel;
@class DatePickerView;
@interface LocalItemDetailViewController : UIViewController <UITextViewDelegate,MKReverseGeocoderDelegate>{
	IBOutlet UITextField *address;
	IBOutlet UITextView *description;
	IBOutlet InputLabel *startDateString;
	IBOutlet InputLabel *endDateString;
	IBOutlet UIButton *doneEditingTextArea;
	DatePickerView *datePicker;
	NSDate *selectedStartDate;
	NSDate *selectedEndDate;
	NSString *saleItemId;
	Boolean isEditing;
	Boolean isNew;
	UIButton *deleteButton;
	CLLocation *myLocation;
}
@property (nonatomic, retain) CLLocation *myLocation;
@property(nonatomic, retain) UIButton *deleteButton;
@property Boolean isEditing;
@property Boolean isNew;
@property(nonatomic, retain) NSString *saleItemId;
@property(nonatomic, retain) IBOutlet UITextField *address;
@property(nonatomic, retain) IBOutlet UITextView *description;
@property(nonatomic, retain) IBOutlet UIButton *doneEditingTextArea;
@property(nonatomic, retain) IBOutlet InputLabel *startDateString;
@property(nonatomic, retain) IBOutlet InputLabel *endDateString;
@property(nonatomic, retain) DatePickerView *datePicker;
@property(nonatomic, retain) NSDate *selectedStartDate;
@property(nonatomic, retain) NSDate *selectedEndDate;

-(IBAction)done:(id)sender;
- (void)showDatePicker:(id)sender;
- (void)removePickerView:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
-(void)donePickDate:(id)sender;
-(void)displayWarning:(NSString*)msg;
-(NSString*)stringFromDate:(NSDate*)date;
-(NSDate*)dateFromString:(NSString*)dateString;
-(IBAction)doneKayboard:(id)sender;
-(IBAction)doneEditingTextArea:(id)sender;
-(void)startDetailForViewOrEdit;
@end
