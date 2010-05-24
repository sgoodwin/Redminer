// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Issue.m instead.

#import "_Issue.h"

@implementation IssueID
@end

@implementation _Issue

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Issue" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Issue";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Issue" inManagedObjectContext:moc_];
}

- (IssueID*)objectID {
	return (IssueID*)[super objectID];
}




@dynamic tracker;






@dynamic priority;






@dynamic desc;






@dynamic id;



- (short)idValue {
	NSNumber *result = [self id];
	return result ? [result shortValue] : 0;
}

- (void)setIdValue:(short)value_ {
	[self setId:[NSNumber numberWithShort:value_]];
}






@dynamic category;






@dynamic subject;






@dynamic assigned_to;






@dynamic updated;



- (BOOL)updatedValue {
	NSNumber *result = [self updated];
	return result ? [result boolValue] : 0;
}

- (void)setUpdatedValue:(BOOL)value_ {
	[self setUpdated:[NSNumber numberWithBool:value_]];
}






@dynamic done_ratio;



- (short)done_ratioValue {
	NSNumber *result = [self done_ratio];
	return result ? [result shortValue] : 0;
}

- (void)setDone_ratioValue:(short)value_ {
	[self setDone_ratio:[NSNumber numberWithShort:value_]];
}






@dynamic status;






@dynamic notes;

	
- (NSMutableSet*)notesSet {
	[self willAccessValueForKey:@"notes"];
	NSMutableSet *result = [self mutableSetValueForKey:@"notes"];
	[self didAccessValueForKey:@"notes"];
	return result;
}
	

@dynamic project;

	




+ (NSArray*)fetchUpdatedIssues:(NSManagedObjectContext*)moc_ {
	NSError *error = nil;
	NSArray *result = [self fetchUpdatedIssues:moc_ error:&error];
	if (error) {
#if TARGET_OS_IPHONE
		NSLog(@"error: %@", error);
#else
		[NSApp presentError:error];
#endif
	}
	return result;
}
+ (NSArray*)fetchUpdatedIssues:(NSManagedObjectContext*)moc_ error:(NSError**)error_ {
	NSError *error = nil;
	
	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"updatedIssues"
													 substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:
														
														nil]
													 ];
	NSAssert(fetchRequest, @"Can't find fetch request named \"updatedIssues\".");
	
	NSArray *result = [moc_ executeFetchRequest:fetchRequest error:&error];
	if (error_) *error_ = error;
	return result;
}



+ (NSArray*)fetchAllIssues:(NSManagedObjectContext*)moc_ {
	NSError *error = nil;
	NSArray *result = [self fetchAllIssues:moc_ error:&error];
	if (error) {
#if TARGET_OS_IPHONE
		NSLog(@"error: %@", error);
#else
		[NSApp presentError:error];
#endif
	}
	return result;
}
+ (NSArray*)fetchAllIssues:(NSManagedObjectContext*)moc_ error:(NSError**)error_ {
	NSError *error = nil;
	
	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"allIssues"
													 substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:
														
														nil]
													 ];
	NSAssert(fetchRequest, @"Can't find fetch request named \"allIssues\".");
	
	NSArray *result = [moc_ executeFetchRequest:fetchRequest error:&error];
	if (error_) *error_ = error;
	return result;
}


@end
