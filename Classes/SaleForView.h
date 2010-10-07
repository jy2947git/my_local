//
//  SaleForView.h
//  mylocal
//
//  Created by You, Jerry on 10/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sale.h"

@interface SaleForView : Sale {
	UIImage *icon;
	NSString *iconUrl;
}
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) NSString *iconUrl;
@end
