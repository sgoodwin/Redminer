//
//  Project.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "Project.h"


@implementation Project
@synthesize id = _id;
@synthesize name = _name;
@synthesize desc = _desc;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
	if(!_undefined_keys){
		_undefined_keys = [[NSSet setWithObject:key] retain];
	}else{
		_undefined_keys = [_undefined_keys setByAddingObject:key];
	}
	NSLog(@"Project couldn't hold onto key: %@", _undefined_keys);
}

+ (id)fromJSONDictionary:(NSDictionary *)jsonDict{
	Project *p = [[[self class] alloc] init];
	p.name = [jsonDict valueForKey:@"name"];
	p.id = [jsonDict valueForKey:@"id"];
	p.desc = [jsonDict valueForKey:@"description"];
	return p;
}

- (NSString*)description{
	return [NSString stringWithFormat:@"<%@ id:%@ name:%@>", [self class],  _id, _name];
}

- (id)copyWithZone:(NSZone *)zone{
    Project *copy = [[[self class] allocWithZone:zone] init];
    [copy setId:[self id]];
	[copy setName:[self name]];
	[copy setDesc:[self desc]];
	
    return copy;
}

@end
