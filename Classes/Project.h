//
//  Project.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSONFriendly.h"
#import "_Project.h"

@interface Project : _Project <JSONFriendly>{
	NSSet *_undefined_keys;
}
+ (Project*)projectWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext*)moc_;
@end
