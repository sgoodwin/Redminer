//
//  Project.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "Project.h"
#import "RedMineSupport.h"

@implementation Project

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
	if(!_undefined_keys){
		_undefined_keys = [[NSSet setWithObject:key] retain];
	}else{
		_undefined_keys = [_undefined_keys setByAddingObject:key];
	}
	NSLog(@"Project couldn't hold onto key: %@", _undefined_keys);
}

+ (id)fromJSONDictionary:(NSDictionary *)jsonDict toManagedObjectContext:(NSManagedObjectContext*)moc_ fromSupport:(RedMineSupport*)support{
	Project *p = [[self class] insertInManagedObjectContext:moc_];
	[p setName:[jsonDict valueForKey:@"name"]];
	[p setId:[jsonDict valueForKey:@"id"]];
	[p setDesc:[jsonDict valueForKey:@"description"]];
	
	NSError *err = nil;
	if([p validateForInsert:&err]){
		[support getIssuesInProject:p];
	}
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

+ (void)checkProject:(Project*)p ForDups:(NSManagedObjectContext*)moc_{
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	[fetch setEntity:[self entityInManagedObjectContext:moc_]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", p.id];
	[fetch setPredicate:predicate];
	
	NSError *err = nil;
	NSArray *results = [moc_ executeFetchRequest:fetch error:&err];
	[fetch release];
	if([results count] > 1){
		NSSet *issues = [p issues];
		// This is a duplicate object and should be deleted. The original should be marked as new as well.
		Project *old = nil;
		for(Project *project in results){
			if(![project isEqualTo:p]){
				old = [project retain];
				[old addIssues:issues];
				[moc_ deleteObject:p];
			}
		}
	}
}

- (NSArray*)updatedIssues:(NSManagedObjectContext*)moc_{
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	[fetch setEntity:[NSEntityDescription entityForName:@"Issue" inManagedObjectContext:moc_]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"updated == TRUE and project.id = %@", self.id];
	[fetch setPredicate:predicate];
	
	NSError *err = nil;
	NSArray *results = [moc_ executeFetchRequest:fetch error:&err];
	[fetch release];
	if(!results){
		NSLog(@"Error fetching updated issues! %@", [err localizedDescription]);
		return nil;
	}
	return results;
}

- (NSDictionary*)dictVersion:(NSManagedObjectContext*)moc_{
	NSArray *values = [NSArray arrayWithObjects:self.name, [NSNumber numberWithUnsignedInteger:[self updatedIssues:moc_].count], nil];
	NSArray *keys = [NSArray arrayWithObjects:kNameKey, kUpdatedCountKey, nil];
	return [[NSDictionary alloc] initWithObjects:values forKeys:keys];
}
@end
