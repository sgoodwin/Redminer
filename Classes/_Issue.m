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






@dynamic done_ratio;



- (short)done_ratioValue {
	NSNumber *result = [self done_ratio];
	return result ? [result shortValue] : 0;
}

- (void)setDone_ratioValue:(short)value_ {
	[self setDone_ratio:[NSNumber numberWithShort:value_]];
}






@dynamic status;






@dynamic read;



- (BOOL)readValue {
	NSNumber *result = [self read];
	return result ? [result boolValue] : 0;
}

- (void)setReadValue:(BOOL)value_ {
	[self setRead:[NSNumber numberWithBool:value_]];
}






@dynamic notes;

	
- (NSMutableSet*)notesSet {
	[self willAccessValueForKey:@"notes"];
	NSMutableSet *result = [self mutableSetValueForKey:@"notes"];
	[self didAccessValueForKey:@"notes"];
	return result;
}
	

@dynamic project;

	



@end
