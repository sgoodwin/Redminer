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
	
	NSNumber *_assigned_to_id;
	NSString *_subject;
	NSNumber *_done_ratio;
	NSNumber *_id;
	NSString *_desc;
}
@property(nonatomic, retain) NSNumber *assigned_to_id;
@property(nonatomic, retain) NSString *subject;
@property(nonatomic, retain) NSNumber *done_ratio;
@property(nonatomic, retain) NSNumber *id;
@property(nonatomic, retain) NSString *desc;
@end
