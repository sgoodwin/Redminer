// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Journal.m instead.

#import "_Journal.h"

@implementation JournalID
@end

@implementation _Journal

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Journal" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Journal";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Journal" inManagedObjectContext:moc_];
}

- (JournalID*)objectID {
	return (JournalID*)[super objectID];
}




@dynamic journalID;



- (short)journalIDValue {
	NSNumber *result = [self journalID];
	return result ? [result shortValue] : 0;
}

- (void)setJournalIDValue:(short)value_ {
	[self setJournalID:[NSNumber numberWithShort:value_]];
}






@dynamic id;



- (short)idValue {
	NSNumber *result = [self id];
	return result ? [result shortValue] : 0;
}

- (void)setIdValue:(short)value_ {
	[self setId:[NSNumber numberWithShort:value_]];
}






@dynamic journalType;






@dynamic user_id;



- (short)user_idValue {
	NSNumber *result = [self user_id];
	return result ? [result shortValue] : 0;
}

- (void)setUser_idValue:(short)value_ {
	[self setUser_id:[NSNumber numberWithShort:value_]];
}






@dynamic notes;









+ (NSArray*)fetchAllJournals:(NSManagedObjectContext*)moc_ {
	NSError *error = nil;
	NSArray *result = [self fetchAllJournals:moc_ error:&error];
	if (error) {
#if TARGET_OS_IPHONE
		NSLog(@"error: %@", error);
#else
		[NSApp presentError:error];
#endif
	}
	return result;
}
+ (NSArray*)fetchAllJournals:(NSManagedObjectContext*)moc_ error:(NSError**)error_ {
	NSError *error = nil;
	
	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"allJournals"
													 substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:
														
														nil]
													 ];
	NSAssert(fetchRequest, @"Can't find fetch request named \"allJournals\".");
	
	NSArray *result = [moc_ executeFetchRequest:fetchRequest error:&error];
	if (error_) *error_ = error;
	return result;
}


@end
