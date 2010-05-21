//
//  Project.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSONFriendly.h"

@interface Project : NSObject <JSONFriendly>{
	NSNumber *_id;
	NSSet *_undefined_keys;
	NSString *_name, *_desc;
}
@property(nonatomic, retain) NSNumber *id;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *desc;
@end
