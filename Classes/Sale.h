//
//  Sale.h
//  mylocal
//
//  model to represent one Sale activity. This must match the server side Sale class so to transpart
//  through JSON.
//  retainright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class SaleItem;
@interface Sale : NSObject {
	NSString *saleId;
	NSString *userUniqueId; //identifier of the seller
//	NSMutableArray *items;
	NSString *startDate;
	NSString *endDate;
	NSString *latitude;
	NSString *longitude;
	NSString *address1;
	NSString *address2;
	NSString *city;
	NSString *state;
	NSString *zipcode;
	NSString *countryCode;
	NSMutableArray *images; //list of ImageInfo object
	NSString *phone;
	NSString *email;
	NSString *detail;
	NSString *status;
	NSString *iconImageBlobKey;
	UIImage *icon; //for display purpose only not persistened.
}
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *saleId;
@property (nonatomic, retain) NSString *userUniqueId;
//@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *address1;
@property (nonatomic, retain) NSString *address2;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *zipcode;
@property (nonatomic, retain) NSString *countryCode;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSString *detail;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *iconImageBlobKey;
@property (nonatomic, retain) UIImage *icon;
- (NSDictionary*)toDictionary;
- (void)fromDictionary:(NSDictionary*)dictionary;
- (NSString*)toJson;
- (void)fromJson:(NSString*)jsonString;
//- (void)addSaleItem:(SaleItem*)item;
@end
