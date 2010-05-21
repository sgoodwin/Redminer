//
//  Issue.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "Issue.h"

@implementation Issue
@synthesize assigned_to_id = _assigned_to_id;
@synthesize subject = _subject;
@synthesize done_ratio = _done_ratio;
@synthesize id = _id;
@synthesize desc = _desc;


+ (id)fromJSONDictionary:(NSDictionary *)jsonDict{
	Issue *i = [[[self class] alloc] init];
	NSLog(@"Issue dict: %@", jsonDict);
	i.assigned_to_id = [jsonDict valueForKey:@"assigned_to_id"];
	i.subject = [jsonDict valueForKey:@"subject"];
	i.done_ratio = [NSNumber numberWithInt:[[jsonDict valueForKey:@"done_ratio"] intValue]];
	i.id = [NSNumber numberWithInt:[[jsonDict valueForKey:@"id"] intValue]];
	i.desc = [jsonDict valueForKey:@"description"];
	return i;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
	if(!_undefined_keys){
		_undefined_keys = [[NSSet setWithObject:key] retain];
	}else{
		_undefined_keys = [_undefined_keys setByAddingObject:key];
	}
	NSLog(@"Issue couldn't hold onto key: %@", _undefined_keys);
}

- (NSString*)description{
	return [NSString stringWithFormat:@"<Item id:%@ subject:%@ assigned_to:%@ done:%@>", self.id, self.subject, self.assigned_to_id, self.done_ratio];
}

- (id)copyWithZone:(NSZone *)zone{
    Issue *copy = [[[self class] allocWithZone:zone] init];
    [copy setAssigned_to_id:[self assigned_to_id]];
	[copy setSubject:[self subject]];
	[copy setDone_ratio:[self done_ratio]];
	[copy setId:[self id]];
	[copy setDesc:[self desc]];
	
    return copy;
}

@end
