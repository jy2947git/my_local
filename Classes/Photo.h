//
//  Photo.h
//  mylocal
//
//  Created by You, Jerry on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Event;

@interface Photo :  NSManagedObject  
{
}

@property (nonatomic, retain) id image;
@property (nonatomic, retain) Event * event;

@end



