//
//  User.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/15/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "User.h"
#import "RedMineSupport.h"

@implementation User

+ (id)fromJSONDictionary:(NSDictionary *)jsonDict toManagedObjectContext:(NSManagedObjectContext*)moc_ fromSupport:(RedMineSupport*)support{
	User *u = [[self class] insertInManagedObjectContext:moc_];
	u.id = [jsonDict valueForKey:@"id"];
	u.name = [jsonDict valueForKey:@"name"];
	return u;
}

- (NSString*)description{
	return [NSString stringWithFormat:@"<%@ id:%@ name:%@>", [self class],  [self id], [self name]];
}
@end
