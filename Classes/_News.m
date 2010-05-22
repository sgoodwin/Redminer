// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to News.m instead.

#import "_News.h"

@implementation NewsID
@end

@implementation _News

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"News";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"News" inManagedObjectContext:moc_];
}

- (NewsID*)objectID {
	return (NewsID*)[super objectID];
}







+ (NSArray*)fetchAllNews:(NSManagedObjectContext*)moc_ {
	NSError *error = nil;
	NSArray *result = [self fetchAllNews:moc_ error:&error];
	if (error) {
#if TARGET_OS_IPHONE
		NSLog(@"error: %@", error);
#else
		[NSApp presentError:error];
#endif
	}
	return result;
}
+ (NSArray*)fetchAllNews:(NSManagedObjectContext*)moc_ error:(NSError**)error_ {
	NSError *error = nil;
	
	NSManagedObjectModel *model = [[moc_ persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"allNews"
													 substitutionVariables:[NSDictionary dictionaryWithObjectsAndKeys:
														
														nil]
													 ];
	NSAssert(fetchRequest, @"Can't find fetch request named \"allNews\".");
	
	NSArray *result = [moc_ executeFetchRequest:fetchRequest error:&error];
	if (error_) *error_ = error;
	return result;
}


@end
