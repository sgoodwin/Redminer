//
//  Issue.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "Issue.h"
#import "Project.h"

@interface Issue (PrivateMethods)
- (NSString*)categoryOrBlank;
- (NSString*)htmlReadyDesc;
- (NSString*)htmlReadyNotes;
@end

@implementation Issue

+ (id)fromJSONDictionary:(NSDictionary *)jsonDict toManagedObjectContext:(NSManagedObjectContext*)moc_{
	Issue *i = [[self class] insertInManagedObjectContext:moc_];
	i.subject = [jsonDict valueForKey:@"subject"];
	i.done_ratio = [NSNumber numberWithInt:[[jsonDict valueForKey:@"done_ratio"] intValue]];
	i.id = [NSNumber numberWithInt:[[jsonDict valueForKey:@"id"] intValue]];
	i.desc = [jsonDict valueForKey:@"description"];
	return i;
}

+ (Issue*)checkIssue:(Issue*)i ForDups:(NSManagedObjectContext*)moc_{
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	[fetch setEntity:[self entityInManagedObjectContext:moc_]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", i.id];
	[fetch setPredicate:predicate];
	
	NSError *err = nil;
	NSArray *results = [moc_ executeFetchRequest:fetch error:&err];
	NSLog(@"got results: %@", results);
	[fetch release];
	if([results count] > 1){
		NSSet *notes = [i notes];
		Project *p = [i project];
		NSString *assigned_to = [i assigned_to];
		NSString *category = [i category];
		NSString *desc = [i desc];
		NSNumber *done_ratio = [i done_ratio];
		NSNumber *an_id = [i id];
		NSString *priority = [i priority];
		NSString *status = [i status];
		NSString *subject = [i subject];
		NSString *tracker = [i tracker];
		
		[moc_ deleteObject:i];
		for(Issue *issue in results){
			[moc_ deleteObject:issue];
		}
		
		Issue *new = [Issue insertInManagedObjectContext:moc_];
		new.notes = notes;
		new.project = p;
		new.assigned_to = assigned_to;
		new.category = category;
		new.desc = desc;
		new.done_ratio = done_ratio;
		new.id = an_id;
		new.priority = priority;
		new.status = status;
		new.subject = subject;
		new.tracker = tracker;
		new.updatedValue = YES;
		
		NSError *err = nil;
		if(![moc_ save:&err]){
			NSLog(@"Failed to save dup-check for Issue: %@, %@", new, [err localizedDescription]);
			return nil;
		}
		
		return new;
	}
	return i;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
	if(!_undefined_keys){
		_undefined_keys = [[NSSet setWithObject:key] retain];
	}else{
		_undefined_keys = [_undefined_keys setByAddingObject:key];
	}
}

- (NSString*)description{
	return [NSString stringWithFormat:@"<Item id:%@ subject:%@ assigned_to:%@ done:%@ status:%@ notes:%d updated:%@>", self.id, self.subject, self.assigned_to, self.done_ratio, self.status, [[self notes] count], [self updated]];
}

- (NSString*)categoryOrBlank{
	if(self.category)
		return [NSString stringWithFormat:@"Category: %@", self.category];
	return @"";
}

- (NSString*)htmlReadyDesc{
	NSArray *paragraphs = [self.desc componentsSeparatedByString:@"\n"];
	NSMutableString *html = [NSMutableString string];
	for(NSString *p in paragraphs){
		[html appendFormat:@"<p>%@</p>", p];
	}
	
	return html;
}

- (NSString*)htmlReadyNotes{
	NSMutableString *html = [NSMutableString stringWithString:@"<ul>"];
	for(Note *n in self.notes){
		[html appendFormat:@"<li>%@</li>", [n htmlString]];
	}
	[html appendString:@"</ul>"];
	return html;
}

- (NSString*)htmlString {
	NSString *html = [NSString stringWithFormat:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"><html lang=\"en\"> \
					  <head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><title>untitled</title></head> \
					  <body> \
						<div id=\"subject\"><strong>Subject:</strong> %@</div> \
						<div id=\"category\">%@</div> \
						<div id=\"done_ratio\"><strong>%@%% complete</strong></div> \
						<div id=\"status\"><strong>Status:</strong> %@</div> \
						<div id=\"assigned_to\"><strong>Assigned to:</strong> %@</div> \
						<div id=\"description\"><strong>Description:</strong> %@</div> \
						<div id=\"notes\"><strong>Notes:</strong> %@</div> \
					  </body></html>", self.subject, [self categoryOrBlank], self.done_ratio, self.status, self.assigned_to, [self htmlReadyDesc], [self htmlReadyNotes]];
	return html;
}

/*- (id)copyWithZone:(NSZone *)zone{
    Issue *copy = [[[self class] allocWithZone:zone] init];
    [copy setAssigned_to_id:[self assigned_to_id]];
	[copy setSubject:[self subject]];
	[copy setDone_ratio:[self done_ratio]];
	[copy setId:[self id]];
	[copy setDesc:[self desc]];
	
    return copy;
}*/

- (NSSet*)interestingKeys{
	return [NSSet setWithObjects:@"assigned_to", @"category", @"done_ratio", @"priority", @"status", @"tracker", @"id", nil];
}

- (BOOL)isEqualTo:(Issue*)object{
	BOOL yesNo = YES;
	for(NSString *key in [self interestingKeys]){
		if([self valueForKey:key] && ![[self valueForKey:key] isEqualTo:[object valueForKey:key]]){
			yesNo = NO;
		}
	}
	return yesNo;
}

+ (Issue*)issueWithID:(NSNumber *)an_id inManagedObjectContext:(NSManagedObjectContext*)moc_{
	NSFetchRequest *request = [[NSFetchRequest alloc]  init];
	[request setEntity:[NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:moc_]];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", an_id];
	[request setPredicate:predicate];
	
	NSError *err = nil;
	NSArray *results = [moc_ executeFetchRequest:request error:&err];
	[request release];
	if(!!results && [results count] > 0)
		return [results objectAtIndex:0];
	return nil;
}

- (NSDictionary*)dictVersion:(NSManagedObjectContext*)moc_{
	NSArray *values = [NSArray arrayWithObjects:self.desc, self.id, self.subject,self.done_ratio, nil];
	NSArray *keys = [NSArray arrayWithObjects:kDescKey, kIDKey, kSubjectKey, kdDoneRatioKey, nil];
	return [[NSDictionary alloc] initWithObjects:values forKeys:keys];
}
@end
