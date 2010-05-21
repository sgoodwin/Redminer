//
//  Journal.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/15/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "Journal.h"


@implementation Journal
@synthesize id = _id;
@synthesize journalID = _journalID;
@synthesize journalType = _journalType;
@synthesize notes = _notes;
@synthesize user_id = _user_id;

+ (id)fromJSONDictionary:(NSDictionary *)jsonDict{
	Journal *j = [[[self class] alloc] init];
	j.journalID = [jsonDict valueForKey:@"journalized_id"];
	j.journalType = [jsonDict valueForKey:@"journalized_type"];
	j.id = [jsonDict valueForKey:@"id"];
	j.notes = [jsonDict valueForKey:@"notes"];
	j.user_id = [jsonDict valueForKey:@"user_id"];
	return j;
}

- (NSString*)description{
	return [NSString stringWithFormat:@"<%@ id:%@ type:%@ notes:%@>", [self class],  _id, _journalType, _notes];
}
@end
