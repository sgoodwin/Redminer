//
//  Project.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "Project.h"
#import "Issue.h"

@implementation Project

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
	if(!_undefined_keys){
		_undefined_keys = [[NSSet setWithObject:key] retain];
	}else{
		_undefined_keys = [_undefined_keys setByAddingObject:key];
	}
	NSLog(@"Project couldn't hold onto key: %@", _undefined_keys);
}

+ (id)fromJSONDictionary:(NSDictionary *)jsonDict toManagedObjectContext:(NSManagedObjectContext*)moc_{
	Project *p = [[self class] insertInManagedObjectContext:moc_];
	[p setName:[jsonDict valueForKey:@"name"]];
	[p setId:[jsonDict valueForKey:@"id"]];
	[p setDesc:[jsonDict valueForKey:@"description"]];
	return p;
}

- (NSString*)description{
	return [NSString stringWithFormat:@"<%@ id:%@ name:%@ issues:%d>", [self class],  [self id], [self name], [[self issues] count]];
}

+ (Project*)projectWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext*)moc_{
	NSFetchRequest *request = [[NSFetchRequest alloc]  init];
	[request setEntity:[NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:moc_]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name matches %@", name];
	[request setPredicate:predicate];
	
	NSError *err = nil;
	NSArray *results = [moc_ executeFetchRequest:request error:&err];
	[request release];
	if(!!results && [results count] > 0)
		return [results objectAtIndex:0];
	return nil;
}

+ (Project *)checkProject:(Project*)p ForDups:(NSManagedObjectContext*)moc_{
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	[fetch setEntity:[self entityInManagedObjectContext:moc_]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", p.id];
	[fetch setPredicate:predicate];
	
	NSError *err = nil;
	NSArray *results = [moc_ executeFetchRequest:fetch error:&err];
	[fetch release];
	if([results count] > 1){
		NSSet *issues = [p issues];
		NSString *desc = [p desc];
		NSNumber *an_id = [p id];
		NSString *name = [p name];
		
		for(Project *project in results){
			[moc_ deleteObject:project];
		}
		
		Project *new = [[self class] insertInManagedObjectContext:moc_];
		[new setIssues:issues];
		[new setDesc:desc];
		[new setName:name];
		new.id = an_id;
		
		NSError *err = nil;
		if(![moc_ save:&err]){
			NSLog(@"Failed to save updated project!");
		}
		
		return new;
	}
	return p;
}

- (NSArray*)unreadIssues{
	NSArray *issues = [[self issues] allObjects];
	NSMutableArray *unread = [NSMutableArray array];
	[issues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop){
		if(![(Issue*)obj readValue]){
			[unread addObject:obj];
		}
	}];
	return unread;
}

- (NSArray*)sortedIssues{
	NSArray *array = [[self issues] allObjects];
	return [array sortedArrayUsingComparator: ^(id obj1, id obj2) {
		
		if ([(Issue*)obj1 done_ratioValue] > [(Issue*)obj2 done_ratioValue]) {
			return (NSComparisonResult)NSOrderedDescending;
		}
		
		if ([(Issue*)obj1 done_ratioValue] < [(Issue*)obj2 done_ratioValue]) {
			return (NSComparisonResult)NSOrderedAscending;
		}
		return (NSComparisonResult)NSOrderedSame;
	}];
}

- (NSDictionary*)dictVersion:(NSManagedObjectContext*)moc_{
	NSArray *values = [NSArray arrayWithObjects:self.name, self.id, [NSNumber numberWithUnsignedInteger:[self sortedIssues].count], [NSNumber numberWithUnsignedInteger:[[self unreadIssues] count]], nil];
	NSArray *keys = [NSArray arrayWithObjects:kNameKey, kIDKey, kItemCountKey, kUnreadCountKey, nil];
	return [[NSDictionary alloc] initWithObjects:values forKeys:keys];
}
@end
