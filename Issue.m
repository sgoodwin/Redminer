//
//  Issue.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "Issue.h"


@implementation Issue
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
	if(!_undefined_keys){
		_undefined_keys = [[NSSet setWithObject:key] retain];
	}else{
		_undefined_keys = [_undefined_keys setByAddingObject:key];
	}
	NSLog(@"Issue couldn't hold onto key: %@", _undefined_keys);
}

- (NSString*)description{
	return [NSString stringWithFormat:@"Item {:subject =>%@, :assigned_to=>%@", subject, assigned_to];
}
@end
