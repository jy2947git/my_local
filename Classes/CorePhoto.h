//
//  CorePhoto.h
//  mylocal
//
//  Created by You, Jerry on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface CorePhoto :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * blobKey;
@property (nonatomic, retain) id image;

@end



