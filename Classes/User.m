//
//  User.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/15/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "User.h"


@implementation User
+ (id)fromJSONDictionary:(NSDictionary *)jsonDict{
	User *u = [[User alloc] init];
	NSLog(@"User Dictionary: %@", jsonDict);
	return u;
}
@end
