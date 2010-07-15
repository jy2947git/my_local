//
//  SaleItemCell.h
//  mylocal
//
//  Created by Junqiang You on 5/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocation;
@interface SaleItemCell : UITableViewCell {


	CLLocation *myLocation;
	UILabel *orderLabel;
	UILabel *titleLabel;
	UILabel *parLabel;
	UILabel *bestScoreLabel;
}
@property (nonatomic, retain) UILabel *orderLabel;
@property (nonatomic, retain) CLLocation *myLocation;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *parLabel;
@property (nonatomic, retain) UILabel *bestScoreLabel;

-(UILabel *)newLabelWithPrimaryColor:(UIColor*)primaryColor selectedColor:(UIColor*)selectedColor fontSize:(CGFloat)fontSize bold:(Boolean)bold;
-(void)setSaleItemOrder:(NSInteger)order Address:(NSString *)address description:(NSString *)description distance:(NSString*)distance startDate:(NSString *)startDate endDate:(NSString *)endDate;
@end
