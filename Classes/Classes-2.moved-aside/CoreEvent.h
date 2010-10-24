//
//  CoreEvent.h
//  mylocal
//
//  Created by You, Jerry on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CorePhoto;

@interface CoreEvent :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSSet* photos;

@end


@interface CoreEvent (CoreDataGeneratedAccessors)
- (void)addPhotosObject:(CorePhoto *)value;
- (void)removePhotosObject:(CorePhoto *)value;
- (void)addPhotos:(NSSet *)value;
- (void)removePhotos:(NSSet *)value;

@end

