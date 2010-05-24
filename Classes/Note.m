#import "Note.h"
#import "GOLogger.h"

@implementation Note

// Custom logic goes here.

- (NSString*)description{
	return [NSString stringWithFormat:@"<Note id:%@ name:%@ notes length:%d>", self.id, self.name, [self.notes length]];
}

+ (void)checkNote:(Note*)n ForDups:(NSManagedObjectContext*)moc_{
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	[fetch setEntity:[self entityInManagedObjectContext:moc_]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", n.id];
	[fetch setPredicate:predicate];
	
	NSError *err = nil;
	NSArray *results = [moc_ executeFetchRequest:fetch error:&err];
	[fetch release];
	if([results count] > 1){
		Issue *issue = [n issue];
		// This is a duplicate object and should be deleted. The original should be marked as new as well.
		Note *old = [results objectAtIndex:0];
		if(![old isEqualTo:n]){
			[old setUpdatedValue:YES];
		}
		[moc_ deleteObject:n];
		[old setIssue:issue];
	}
}

- (NSSet*)interestingKeys{
	return [NSSet setWithObjects:@"notes", nil];
}

- (BOOL)isEqualTo:(id)object{
	BOOL yesNo = YES;
	for(NSString *key in [self interestingKeys]){
		if(![[self valueForKey:key] isEqualTo:[object valueForKey:key]]){
			yesNo = NO;
		}
	}
	return yesNo;
}
@end
