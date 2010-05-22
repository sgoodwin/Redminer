//
//  Issue.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSONFriendly.h"
#import "_Issue.h"

@interface Issue : _Issue <JSONFriendly>{
	NSSet *_undefined_keys;
}
@end
