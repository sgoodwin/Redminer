//
//  Journal.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/15/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSONFriendly.h"
#import "_Journal.h"

@interface Journal : _Journal<JSONFriendly> {
	NSString *_journalType;
	NSNumber *_journalID;
	NSNumber *_id;
	NSString *_notes;
	NSNumber *_user_id;
}
@property(nonatomic, retain) NSString *journalType;
@property(nonatomic, retain) NSNumber *journalID;
@property(nonatomic, retain) NSNumber *id;
@property(nonatomic, retain) NSString *notes;
@property(nonatomic, retain) NSNumber *user_id;
@end
