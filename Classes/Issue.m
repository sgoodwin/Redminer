//
//  Issue.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "Issue.h"
#import "Project.h"
#import "RedMineSupport.h"

@implementation Issue

+ (id)fromJSONDictionary:(NSDictionary *)jsonDict toManagedObjectContext:(NSManagedObjectContext*)moc_ fromSupport:(RedMineSupport*)support{
	Issue *i = [[self class] insertInManagedObjectContext:moc_];
	i.subject = [jsonDict valueForKey:@"subject"];
	i.done_ratio = [NSNumber numberWithInt:[[jsonDict valueForKey:@"done_ratio"] intValue]];
	i.id = [NSNumber numberWithInt:[[jsonDict valueForKey:@"id"] intValue]];
	i.desc = [jsonDict valueForKey:@"description"];
	return i;
}

+ (void)checkIssue:(Issue*)i ForDups:(NSManagedObjectContext*)moc_{
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	[fetch setEntity:[self entityInManagedObjectContext:moc_]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", i.id];
	[fetch setPredicate:predicate];
	
	NSError *err = nil;
	NSArray *results = [moc_ executeFetchRequest:fetch error:&err];
	[fetch release];
	if([results count] > 1){
		NSSet *notes = [i notes];
		Project *p = [i project];
		Issue *old = nil;
		for(Issue *issue in results){
			if(![issue isEqualTo:i]){
				old = issue;
				[old setUpdatedValue:YES];
				[moc_ deleteObject:i];
				// This is a duplicate object and should be deleted. The original should be marked as new as well.
				[old setProject:p];
				[old addNotes:notes];
			}
		}
	}
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
	if(!_undefined_keys){
		_undefined_keys = [[NSSet setWithObject:key] retain];
	}else{
		_undefined_keys = [_undefined_keys setByAddingObject:key];
	}
}

- (NSString*)description{
	return [NSString stringWithFormat:@"<Item id:%@ subject:%@ assigned_to:%@ done:%@ status:%@ notes:%d updated:%@>", self.id, self.subject, self.assigned_to, self.done_ratio, self.status, [[self notes] count], [self updated]];
}

/*- (id)copyWithZone:(NSZone *)zone{
    Issue *copy = [[[self class] allocWithZone:zone] init];
    [copy setAssigned_to_id:[self assigned_to_id]];
	[copy setSubject:[self subject]];
	[copy setDone_ratio:[self done_ratio]];
	[copy setId:[self id]];
	[copy setDesc:[self desc]];
	
    return copy;
}*/

- (NSSet*)interestingKeys{
	return [NSSet setWithObjects:@"assigned_to", @"category", @"done_ratio", @"priority", @"status", @"tracker", nil];
}

- (BOOL)isEqualTo:(Issue*)object{
	BOOL yesNo = YES;
	for(NSString *key in [self interestingKeys]){
		if([self valueForKey:key] && ![[self valueForKey:key] isEqualTo:[object valueForKey:key]]){
			yesNo = NO;
		}
	}
	return yesNo;
}
@end
