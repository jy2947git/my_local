//
//  CorePhoto.h
//  mylocal
//
//  Created by You, Jerry on 10/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface CorePhoto :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * thumbNailBlobKey;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) id thumbNailImage;
@property (nonatomic, retain) NSString * blobKey;

@end



