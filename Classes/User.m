//
//  User.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/15/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "User.h"


@implementation User
@synthesize id = _id;
@synthesize name = _name;

+ (id)fromJSONDictionary:(NSDictionary *)jsonDict{
	User *u = [[User alloc] init];
	u.id = [jsonDict valueForKey:@"id"];
	u.name = [jsonDict valueForKey:@"name"];
	return u;
}

- (NSString*)description{
	return [NSString stringWithFormat:@"<%@ id:%@ name:%@>", [self class],  _id, _name];
}
@end
