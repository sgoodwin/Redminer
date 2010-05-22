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
	return [NSString stringWithFormat:@"<%@ id:%@ name:%@>", [self class],  [self id], [self name]];
}

/*- (id)copyWithZone:(NSZone *)zone{
    Project *copy = [[[self class] allocWithZone:zone] init];
    [copy setId:[self id]];
	[copy setName:[self name]];
	[copy setDesc:[self desc]];
	
    return copy;
}*/


+ (Project*)projectWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext*)moc_{
	NSFetchRequest *request = [[NSFetchRequest alloc]  init];
	[request setEntity:[NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:moc_]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name matches %@", name];
	[request setPredicate:predicate];
	
	NSError *err = nil;
	NSArray *results = [moc_ executeFetchRequest:request error:&err];
	if(!!results)
		return [results objectAtIndex:0];
	return nil;
}
@end
