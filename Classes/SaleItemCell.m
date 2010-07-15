//
//  SaleItemCell.m
//  mylocal
//
//  Created by Junqiang You on 5/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SaleItemCell.h"
#import "CoreLocation/CLLocation.h"

@implementation SaleItemCell
@synthesize titleLabel;
@synthesize parLabel;
@synthesize bestScoreLabel;
@synthesize myLocation;
@synthesize orderLabel;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		self.imageView.image=[UIImage imageNamed:@"table-cell-number.png"];
		DebugLog(@"image view size %i", self.imageView.bounds.size.width);
		//DebugLog(@"frame %i %i %i %i", self.imageView.frame.origin.x,self.imageView.frame.origin.y,self.imageView.frame.size.width, self.imageView.frame.size.height);
		UILabel *n = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
		n.backgroundColor=[UIColor clearColor];
		n.textColor=[UIColor whiteColor];
		n.font=[UIFont systemFontOfSize:10];
		n.textAlignment=UITextAlignmentCenter;
		self.orderLabel=n;
		[self.imageView addSubview:self.orderLabel];
		[n release];
		// Initialization code
		UIView *contentView = self.contentView;
		DebugLog(@"content view x=%i",self.contentView.frame.origin.x);
		//puzzle name
		UILabel *newlabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:NO]; 
		self.titleLabel = newlabel;
		self.titleLabel.textAlignment=UITextAlignmentLeft;
		[self.titleLabel setNumberOfLines:0];
		[contentView addSubview:self.titleLabel];
		[newlabel release];
		//puzzle par
		UILabel *newparlabel = [self newLabelWithPrimaryColor:[UIColor lightGrayColor] selectedColor:[UIColor lightGrayColor] fontSize:12.0 bold:NO]; 
		self.parLabel = newparlabel;
		self.parLabel.textAlignment=UITextAlignmentRight;
		[contentView addSubview:self.parLabel];
		[newparlabel release];
		//best score
		UILabel *scorelabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO]; 
		self.bestScoreLabel = scorelabel;
		self.bestScoreLabel.textAlignment=UITextAlignmentRight;
		[contentView addSubview:self.bestScoreLabel];
		[scorelabel release];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setSaleItemOrder:(NSInteger)order Address:(NSString *)address description:(NSString *)description distance:(NSString*)distance startDate:(NSString *)startDate endDate:(NSString *)endDate{
	NSString *os = [[NSString alloc] initWithFormat:@"%i",order];
	self.orderLabel.text=os;
	[os release];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSDate *sd = [dateFormatter dateFromString:startDate];
	NSDate *ed = [dateFormatter dateFromString:endDate];
	[dateFormatter setDateFormat:@"MM/dd"];
	self.titleLabel.text=address;
	NSString *s = [[NSString alloc] initWithFormat:@"%@ - %@",[dateFormatter stringFromDate:sd],[dateFormatter stringFromDate:ed]];
	self.parLabel.text=s;
	[s release];
	[dateFormatter release];
	NSString *ds = [[NSString alloc]initWithFormat:@"%@",distance];
	self.bestScoreLabel.text=ds;
	[ds release];
}

-(void)layoutSubviews{
	[super layoutSubviews];
	CGRect contentRect = self.contentView.bounds;
	if(!self.editing){
		CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
		frame = CGRectMake(boundsX+45, 2, 150, 60);
		self.titleLabel.frame=frame;
		frame=CGRectMake(boundsX+195, 32, 120, 28);
		self.parLabel.frame=frame;
		frame=CGRectMake(boundsX+220, 2, 95, 28);
		self.bestScoreLabel.frame=frame;
	}
}

-(UILabel *)newLabelWithPrimaryColor:(UIColor*)primaryColor selectedColor:(UIColor*)selectedColor fontSize:(CGFloat)fontSize bold:(Boolean)bold{
		UIFont *font;
		if(bold){
			font = [UIFont boldSystemFontOfSize:fontSize];
		}else{
			font = [UIFont systemFontOfSize:fontSize];
		}
	UILabel *newlabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newlabel.backgroundColor=[UIColor whiteColor];
	newlabel.opaque=YES;
		newlabel.textColor=primaryColor;
		newlabel.highlightedTextColor=selectedColor;
		newlabel.font = font;
	return newlabel;
}

- (void)dealloc {
	[orderLabel release];
	[myLocation release];
	[titleLabel release];
	[parLabel release];
	[bestScoreLabel release];
	
    [super dealloc];
}


@end
