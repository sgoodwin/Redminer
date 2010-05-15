//
//  Project.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "Project.h"


@implementation Project
@synthesize id;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
	if(!_undefined_keys){
		_undefined_keys = [[NSSet setWithObject:key] retain];
	}else{
		_undefined_keys = [_undefined_keys setByAddingObject:key];
	}
	NSLog(@"Project couldn't hold onto key: %@", _undefined_keys);
}

+ (id)fromJSONDictionary:(NSDictionary *)jsonDict{
	Project *p = [[Project alloc] init];
	NSLog(@"Project Dictionary: %@", jsonDict);
	return p;
}
@end
