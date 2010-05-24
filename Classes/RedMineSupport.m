//
//  RedMineSupport.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "RedMineSupport.h"
#import "Project.h"
#import "Note.h"
#import "Issue.h"
#import "NSArrayAdditions.h"
#import "CoreDataVendor.h"
#import "GOLogger.h"

@interface RedMineSupport(PrivateMethods)
- (void)getIssues;
- (void)getProjects;
- (void)getActivity;
- (NSSet*)interestingKeys;
- (void)arrayFromData:(NSData*)data;
- (id)currentItem;
@end

@implementation RedMineSupport
@synthesize key = _key;
@synthesize host = _host;
@synthesize moc = _moc;

@synthesize currentIssue = _currentIssue;
@synthesize currentProject = _currentProject;
@synthesize keyInProgress = _keyInProgress;
@synthesize textInProgress = _textInProgress;
@synthesize currentNote = _currentNote;


- (void)refresh{
	[self getProjects];
	
	NSError *err = nil;
	[[self moc] save:&err];
	if(!!err){
		NSLog(@"Failed to save managed object context in redmine support: %@, %@, %@", [err localizedDescription], [err localizedRecoveryOptions], [err localizedFailureReason]);
	}
}

- (NSArray*)issues{
	return [Issue fetchAllIssues:[self moc]];
}

- (NSArray*)projects{
	return [Project fetchAllProjects:[self moc]];
}

- (NSArray*)issuesInProject:(Project*)project{
	return [[project issues] allObjects];
}

- (NSArray*)updatedIssuesInProject:(Project*)project{
	return [project updatedIssues:[self moc]];
}

- (void)getIssues{
	NSString *requestString = [NSString stringWithFormat:@"http://%@/issues.xml?key=%@", self.host, self.key];
	//NSLog(@"Requesting issues");
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];// stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[request setValue:@"text/xml" forHTTPHeaderField:@"Accept"];
	[request setHTTPShouldHandleCookies:YES];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return;
	}
	[self arrayFromData:data];
	return;
}

- (void)getInfoForIssue:(Issue*)i{
	[GOLogger log:[NSString stringWithFormat:@"Refreshing info for issue: %@", i]];
	NSString *requestString = [NSString stringWithFormat:@"http://%@/issues/%@.xml?key=%@", self.host, i.id, self.key];
	//NSLog(@"Requesting issues");
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];// stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[request setValue:@"text/xml" forHTTPHeaderField:@"Accept"];
	[request setHTTPShouldHandleCookies:YES];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return;
	}
	[self arrayFromData:data];
	return;
}

- (void)getProjects{
	[GOLogger log:@"Refreshing projects"];
	NSString *requestString = [NSString stringWithFormat:@"http://%@/projects.xml?key=%@", self.host, self.key];
	//NSLog(@"Requesting projects");
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	[request setValue:@"text/xml" forHTTPHeaderField:@"Accept"];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return;
	}
	[self arrayFromData:data];
	return;
}

- (void)getIssuesInProject:(Project*)project{
	[GOLogger log:[NSString stringWithFormat:@"Getting issues for project: %@", project]];
	NSString *requestString = [NSString stringWithFormat:@"http://%@/issues.xml?key=%@&project_id=%@&status_id=*", self.host, self.key, project.id];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	//NSLog(@"Requesting Issues in project %@", project);
	[request setValue:@"text/xml" forHTTPHeaderField:@"Accept"];
	NSError *err = nil;
	NSURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return;
	}
	[self arrayFromData:data];
	return;
}


#pragma mark -
#pragma mark Instance method creation;

- (void)arrayFromData:(NSData *)data{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser parse];
	[parser release];
}

- (NSSet*)interestingKeys{
	return [NSSet setWithObjects:@"project", @"tracker", @"status", @"category", @"subject", @"description", @"done_ratio", @"name", @"id", @"assigned_to", @"notes", @"user", nil];
}

- (NSManagedObjectContext*)moc{
	if(!_moc)
		_moc = [CoreDataVendor newManagedObjectContext];
	return _moc;
}

- (id)currentItem{
	if(!!_currentIssue)
		return _currentIssue;
	if(!!_currentProject)
		return _currentProject;
	if(!!_currentNote)
		return _currentNote;
	return nil;
}

#pragma mark -
#pragma mark XML Delegate methods
- (void)parserDidStartDocument:(NSXMLParser *)parser{
	[self willChangeValueForKey:@"issues"];
	[self willChangeValueForKey:@"projects"];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{	
	// Special case for the project info found in an Issue xml request.
	if([elementName isEqualToString:@"project"] && [attributeDict count] > 0 && self.currentIssue){
		Project *p = [Project projectWithName:[attributeDict valueForKey:@"name"] inManagedObjectContext:[self moc]];
		//NSLog(@"Special case issue<=>project association: %@", p);
		if(!!p){
			[self.currentIssue setProject:p];
		}
		return;
	}

	// Special case for the journal info found in an Issue xml request.
	if([elementName isEqualToString:@"user"] && [attributeDict count] > 0 && self.currentNote){
		//NSLog(@"Special case note username: %@", attributeDict);
		[self.currentNote setIssue:[self currentIssue]];
		[self.currentNote setName:[attributeDict valueForKey:@"name"]];
		return;
	}	
	
	if([elementName isEqualToString:@"status"] && [attributeDict count] > 0 && self.currentIssue){
		//NSLog(@"Special case issue<=>status association: %@", attributeDict);
		[self.currentIssue setStatus:[attributeDict valueForKey:@"name"]];
		return;
	}
	
    // Is it the start of a new Issue?
    if ([elementName isEqual:@"issue"]) {
        self.currentIssue = [Issue insertInManagedObjectContext:[self moc]];
		//NSLog(@"Creating Issue!");
        return;
    }
	
	// Is it the start of a new Project?
    if ([elementName isEqual:@"project"]) {
        self.currentProject = [Project insertInManagedObjectContext:[self moc]];
        return;
    }
	
	// Is it the start of a new Journal?
    if ([elementName isEqual:@"journal"]) {
        self.currentNote = [Note insertInManagedObjectContext:[self moc]];
		[self.currentNote setId:[NSNumber numberWithInt:[[attributeDict valueForKey:@"id"] intValue]]];
        return;
    }
	
    // Is it the title/url for the current item?
    if ([self.interestingKeys containsObject:elementName]) {
        self.keyInProgress = [elementName copy];
		//NSLog(@"### interesting key: %@", self.keyInProgress);
        // This is a string we will append to as the text arrives
        self.textInProgress = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //NSLog(@"ending Element: %@", elementName);
	// Is the current issue complete?
	if([elementName isEqualToString:@"notes"]){
		//NSLog(@"Special case notes assignment");
		[self.currentNote setNotes:self.textInProgress];
		return;
	}
	
	if ([elementName isEqualToString:@"projects"]){
		[[Project fetchAllProjects:[self moc]] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop){
			[GOLogger log:[NSString stringWithFormat:@"Getting issues for project: %@", (Project*)obj]];
			[self getIssuesInProject:(Project*)obj];
			return;
		}];
	}
	
    if ([elementName isEqualToString:@"issue"]) {
		//NSLog(@"finished Issue: %@", [[self currentIssue] description]);
        // Clear the current item
		
		[Issue checkIssue:[self currentIssue] ForDups:[self moc]];
		
        [_currentIssue release];
        self.currentIssue = nil;
        return;
    }

	
	// Is the current project complete?
    if ([elementName isEqualToString:@"project"] && ![self currentIssue]) {		
		//NSLog(@"finished Project: %@", [self currentProject]);
        // Clear the current item
		[Project checkProject:[self currentProject] ForDups:[self moc]];
		
        [_currentProject release];
        self.currentProject = nil;
        return;
    }

	// Is the current journal complete?
    if ([elementName isEqualToString:@"journal"]) {
		//NSLog(@"finished Journal: %@", [self currentNote]);
        // Clear the current item
		
		[Note checkNote:[self currentNote] ForDups:[self moc]];
		
		
        [_currentNote release];
        self.currentNote = nil;
        return;
    }
		
    // Is the current key complete?
    if ([elementName isEqualToString:self.keyInProgress]) {
		NSNumber *number = [NSNumber numberWithInt:[self.textInProgress intValue]];
		if([elementName isEqualToString:@"description"]){
			[[self currentItem] setValue:self.textInProgress forKey:@"desc"];
			//NSLog(@"Assigned special-case desc property: %@ to %@", self.textInProgress, self.keyInProgress);
		}else if(!!number && [[number stringValue] isEqualToString:self.textInProgress]){
			[[self currentItem] setValue:number forKey:self.keyInProgress];
			//NSLog(@"Assigned special-case number property %@ to %@", number, self.keyInProgress);
		}else{
			[[self currentItem] setValue:self.textInProgress forKey:self.keyInProgress];
			//NSLog(@"Assigned normal property %@ to %@", self.textInProgress, self.keyInProgress);
		}
		
        // Clear the text and key
        [_textInProgress release];
        _textInProgress = nil;
        [_keyInProgress release];
        _keyInProgress = nil;
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
	[GOLogger log:@"Ready"];
	NSError *err = nil;
	if(![[self moc] save:&err]){
		NSLog(@"Failed to save! %@",  [err localizedDescription]);
	}
	[self didChangeValueForKey:@"issues"];
	[self didChangeValueForKey:@"projects"];
}

// This method can get called multiple times for the
// text in a single element
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [self.textInProgress appendString:string];
}
@end
