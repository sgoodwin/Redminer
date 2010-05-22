// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Project.m instead.

#import "_Project.h"

@implementation ProjectID
@end

@implementation _Project

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Project";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Project" inManagedObjectContext:moc_];
}

- (ProjectID*)objectID {
	return (ProjectID*)[super objectID];
}




@dynamic id;



- (short)idValue {
	NSNumber *result = [self id];
	return result ? [result shortValue] : 0;
}

- (void)setIdValue:(short)value_ {
	[self setId:[NSNumber numberWithShort:value_]];
}






@dynamic name;






@dynamic desc;






@dynamic issues;

	
- (NSMutableSet*)issuesSet {
	[self willAccessValueForKey:@"issues"];
	NSMutableSet *result = [self mutableSetValueForKey:@"issues"];
	[self didAccessValueForKey:@"issues"];
	return result;
}
	

@dynamic activity;

	
- (NSMutableSet*)activitySet {
	[self willAccessValueForKey:@"activity"];
	NSMutableSet *result = [self mutableSetValueForKey:@"activity"];
	[self didAccessValueForKey:@"activity"];
	return result;
}
	




+ (NSArray*)fetchAllProjects:(NSManagedObjectContext*)moc_ {
	NSError *error = nil;
	NSArray *result = [self fetchAllProjects:moc_ error:&error];
	if (error) {
#if TARGET_OS_IPHONE
		NSLog(@"error: %@", error);
#else
		[NSApp presentError:error];
#endif
	}
	return result;
}
+ (NSArray*)fetchAllProjects:(NSManagedObjectContext*)moc_ error:(NSError**)error_ {
	NSError *error = nil;
	
	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"allProjects"
													 substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:
														
														nil]
													 ];
	NSAssert(fetchRequest, @"Can't find fetch request named \"allProjects\".");
	
	NSArray *result = [moc_ executeFetchRequest:fetchRequest error:&error];
	if (error_) *error_ = error;
	return result;
}


@end
