//
//  Issue.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSONFriendly.h"

@interface Issue : NSObject <JSONFriendly>{
	NSSet *_undefined_keys;
	
	NSDate *due_date;
	NSString *assigned_to;
	NSString *subject;
	NSString *status;
	NSNumber *done_ratio;
	NSString *category;
	NSNumber *id;
}

@end
