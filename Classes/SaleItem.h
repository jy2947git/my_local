//
//  SaleItem.h
//  mylocal
//
//  The model to represent Sale Item
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SaleItem : NSObject {
	NSString *identifier;
	NSString *description;
	NSString *barcode;
	NSString *url;
	NSString *imageUrl;
}
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *barcode;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *imageUrl;

- (NSDictionary*)toDictionary;
- (void)fromDictionary:(NSDictionary*)dictionary;
- (NSString*)toJson;
- (void)fromJson:(NSString*)jsonString;
@end
