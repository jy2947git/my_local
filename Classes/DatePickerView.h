//
//  DatePickerView.h
//  mylocal
//
//  Created by Junqiang You on 5/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DatePickerView : UIView {
	UIDatePicker *datePicker;
	UIButton *doneButton;
}
@property(nonatomic, retain) UIDatePicker *datePicker;
@property(nonatomic, retain) UIButton *doneButton;
-(id)initWithFrame:(CGRect)frame AndDate:(NSDate*)date;
@end
