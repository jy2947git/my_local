//
//  Sale.h
//  mylocal
//
//  model to represent one Sale activity. This must match the server side Sale class so to transpart
//  through JSON.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
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
	NSString *description;
	NSString *status;
}
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *saleId;
@property (nonatomic, copy) NSString *userUniqueId;
//@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *address1;
@property (nonatomic, copy) NSString *address2;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zipcode;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *status;
- (NSDictionary*)toDictionary;
- (void)fromDictionary:(NSDictionary*)dictionary;
- (NSString*)toJson;
- (void)fromJson:(NSString*)jsonString;
//- (void)addSaleItem:(SaleItem*)item;
@end
