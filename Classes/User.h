//
//  User.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/15/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSONFriendly.h"

@interface User : NSObject <JSONFriendly>{
	NSNumber *_id;
	NSString *_name;
}
@property(nonatomic, retain) NSNumber *id;
@property(nonatomic, retain) NSString *name;
@end
