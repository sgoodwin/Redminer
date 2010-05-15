//
//  Project.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Project : NSObject{
	NSNumber *id;
	NSSet *_undefined_keys;
}
@property(nonatomic, retain) NSNumber *id;
@end
