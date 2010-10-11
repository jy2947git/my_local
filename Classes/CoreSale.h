//
//  CoreSale.h
//  mylocal
//
//  Created by You, Jerry on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface CoreSale :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSNumber * saleId;
@property (nonatomic, retain) NSString * userUniqueId;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSString * stateCode;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * zipcode;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * dataVersion;
@property (nonatomic, retain) NSSet* images;

@end


@interface CoreSale (CoreDataGeneratedAccessors)
- (void)addImagesObject:(NSManagedObject *)value;
- (void)removeImagesObject:(NSManagedObject *)value;
- (void)addImages:(NSSet *)value;
- (void)removeImages:(NSSet *)value;

@end

