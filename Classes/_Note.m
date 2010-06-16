// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Note.m instead.

#import "_Note.h"

@implementation NoteID
@end

@implementation _Note

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Note";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Note" inManagedObjectContext:moc_];
}

- (NoteID*)objectID {
	return (NoteID*)[super objectID];
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






@dynamic notes;






@dynamic issue;

	



@end
