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


+ (id)fromJSONDictionary:(NSDictionary *)jsonDict{
	Issue *i = [[Issue alloc] init];
	NSLog(@"Issue Dictionary: %@", jsonDict);
	i.assigned_to_id = [jsonDict valueForKey:@"assigned_to_id"];
	i.subject = [jsonDict valueForKey:@"subject"];
	i.done_ratio = [jsonDict valueForKey:@"done_ratio"];
	i.id = [jsonDict valueForKey:@"id"];
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
	return [NSString stringWithFormat:@"<Item id:%@ subject:%@ assigned_to:%@ done:%@>", _id, _subject, _assigned_to_id, _done_ratio];
}
@end
