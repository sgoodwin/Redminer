//
//  APIOperation.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 6/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "APIOperation.h"
#import "Project.h"
#import "Issue.h"
#import "Note.h"
#import "GOLogger.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "PreferencesController.h"
#import "CoreDataVendor.h"

@interface APIOperation(PrivateMethods)
- (NSString *)key;
- (NSString *)host;
- (BOOL)check;
- (void)save;

- (void)getIssues;
- (void)getProjects;
- (void)getActivity;
- (NSSet*)interestingKeys;
- (void)arrayFromData:(NSData*)data;
- (id)currentItem;

- (void)setFinished:(BOOL)done;
- (void)finish;
@end


@implementation APIOperation
@synthesize issueID = _issueID;
@synthesize projectID = _projectID;
@synthesize type;

@synthesize moc = _moc;
@synthesize currentIssue = _currentIssue;
@synthesize currentProject = _currentProject;
@synthesize keyInProgress = _keyInProgress;
@synthesize textInProgress = _textInProgress;
@synthesize currentNote = _currentNote;

+ (APIOperation *)operationWithType:(APIOperationType)type andObjectID:(NSManagedObjectID*)object_id{
	APIOperation *op = [[self alloc] init];
	op.type = type;
	switch(type){
		case APIOperationProjects:
			break;
		case APIOperationIssuesInProject:
			op.projectID = (ProjectID*)object_id;
			break;
		case APIOperationIssueDetail:
			op.issueID = (IssueID*)object_id;
	}
	return op;
}

+ (NSString*)nameForType:(APIOperationType)aType{
	switch(aType){
		case APIOperationProjects:
			return @"Projects";
			break;
		case APIOperationIssuesInProject:
			return @"Issues in Project";
			break;
		case APIOperationIssueDetail:
			return @"Issue Detail";
			break;
		default:
			return @"Polly should not be!";
	}
}

- (void)save{
	NSError *err = nil;
	if(![[self moc] save:&err]){
		NSLog(@"Failed to save! %@",  [err localizedDescription]);
	}
}

- (void)start{
	//if (![NSThread isMainThread]) {
//        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
//        return;
//    }
	
	NSURL *targetURL = nil;
	Project *project = nil;
	Issue *i = nil;
	
	switch(self.type){
		case APIOperationProjects:
			[GOLogger log:@"Refreshing projects"];
			targetURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/projects.xml?key=%@", self.host, self.key]];
			break;
		case APIOperationIssuesInProject:
			project = (Project*)[[self moc] objectWithID:[self projectID]];
			[GOLogger log:[NSString stringWithFormat:@"Getting issues for project: %@", project]];
			targetURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/issues.xml?key=%@&project_id=%@&status_id=*", self.host, self.key, project.id]];
			break;
		case APIOperationIssueDetail:
			i = (Issue*)[[self moc] objectWithID:[self issueID]];
			[GOLogger log:[NSString stringWithFormat:@"Refreshing info for issue: %@", i]];
			targetURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/issues/%@.xml?key=%@", self.host, i.id, self.key]];
	}
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:targetURL];
	[request setValue:@"text/xml" forHTTPHeaderField:@"Accept"];
	NSError *err = nil;
	NSHTTPURLResponse *response = nil;	
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	if([response statusCode] != 200){
		[GOLogger log:[NSString stringWithFormat:@"Failed request"]];
		return;
	}
	
	if(!!err){
		NSLog(@"Error: %@", [err localizedDescription]);
		return;
	}
	//NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	//NSLog(@"datastring: %@", dataString);
	
	NSLog(@"parsing data: %@", project);
	[self arrayFromData:data];	
}

#pragma mark -
#pragma mark Operation Stuff:

- (NSString*)description{
	return [NSString stringWithFormat:@"<APIOperation type:%@ issueID: %@ projectID: %@>", [[self class] nameForType:self.type], self.issueID, self.projectID];
}

- (BOOL)isConcurrent{
	return YES;
}

- (BOOL)isExecuting{
	return _executing;
}

- (BOOL)isFinished{
	return _finished;
}

- (void)setFinished:(BOOL)done{
	_finished = done;
	_executing = NO;
}

- (void)finish{
	NSLog(@"finishing up %@", self);
	if(!!_data){
		[_data release];
		_data = nil;
	}
	[self willChangeValueForKey:@"isFinished"];
	_finished = YES;
	[self didChangeValueForKey:@"isFinished"];
}


#pragma mark -
#pragma mark Instance method creation

- (NSString*)host{
	return [[PreferencesController sharedPrefsWindowController] server_location];
}

- (NSString*)key{
	return [[PreferencesController sharedPrefsWindowController] access_key];
}

- (void)arrayFromData:(NSData *)data{
	NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"DataString: %@", dataString);
	
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
	NSLog(@"Here we go!");
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
	
	// Special case for the project info found in an Issue xml request.
	if([elementName isEqualToString:@"project"] && [attributeDict count] > 0 && self.currentIssue){
		Project *p = [Project projectWithName:[attributeDict valueForKey:@"name"] inManagedObjectContext:[self moc]];
		//NSLog(@"Special case issue<=>project association: %@", p);
		if(!!p){
			[self.currentIssue setProject:p];
		}
		return;
	}
	
	// Special case for the assigned_to info found in an Issue xml request.
	if([elementName isEqualToString:@"assigned_to"] && [attributeDict count] > 0 && self.currentIssue){
		//NSLog(@"Special case note username: %@", attributeDict);
		[self.currentIssue setAssigned_to:[attributeDict valueForKey:@"name"]];
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
		//[self willChangeValueForKey:@"issues"];
		//NSLog(@"Creating Issue!");
        return;
    }
	
	// Is it the start of a new Project?
    if ([elementName isEqual:@"project"]) {
        self.currentProject = [Project insertInManagedObjectContext:[self moc]];
		//[self willChangeValueForKey:@"projects"];
        return;
    }
	
	// Is it the start of a new Journal?
    if ([elementName isEqual:@"journal"]) {
        self.currentNote = [Note insertInManagedObjectContext:[self moc]];
		[self.currentNote setId:[NSNumber numberWithInt:[[attributeDict valueForKey:@"id"] intValue]]];
        return;
    }
	
	// special case for the name field in Notes
	if([elementName isEqualToString:@"user"] && self.currentNote){
		self.currentNote.name = [attributeDict valueForKey:@"name"];
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
	
    if ([elementName isEqualToString:@"issue"]) {
		[[self currentProject] addIssuesObject:[self currentIssue]];
		[self save];
		[Issue deleteIssuesWithRedmineID:[[self currentIssue] id] inManagedObjectContext:[self moc] butNotIssueID:[[self currentIssue] objectID]];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kAPIOperationIssue object:[[self currentIssue] id]];
		
        [_currentIssue release];
        self.currentIssue = nil;
        return;
    }
	
	if([elementName isEqualToString:@"issues"]){
		if([self currentProject]){
			[[NSNotificationCenter defaultCenter] postNotificationName:kAPIOperationIssues object:[[self currentProject] name]];
		}else{
			[[NSNotificationCenter defaultCenter] postNotificationName:kAPIOperationIssues object:nil];
		}
		return;
	}
	
	// Is the current project complete?
    if ([elementName isEqualToString:@"project"] && ![self currentIssue]) {		
		//NSLog(@"finished Project: %@", [self currentProject]);
        // Clear the current item
		Project *p = [Project checkProject:[self currentProject] ForDups:[self moc]];
		//[self didChangeValueForKey:@"projects"];
		[self save];
		
		APIOperation *op = [APIOperation operationWithType:APIOperationIssuesInProject andObjectID:[p objectID]];
		[[NSOperationQueue currentQueue] addOperation:op];
		
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
	
	if([elementName isEqualToString:@"projects"]){
		[self save];
		[[NSNotificationCenter defaultCenter] postNotificationName:kAPIOperationProjects object:nil];
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
	NSLog(@"Finished parsing");
	[GOLogger log:@"Ready"];
	[self finish];	
}

// This method can get called multiple times for the
// text in a single element
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [self.textInProgress appendString:string];
}

#pragma mark -
#pragma mark Reachability Testing

+ (BOOL)hostIsReachable{
	static BOOL checkNetwork = YES;  
 	static BOOL _isDataSourceAvailable = NO;  
    if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.  
        checkNetwork = NO;  
        Boolean success;  
        const char *host_name = "google.com"; //pretty reliable :)  
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);  
        SCNetworkReachabilityFlags flags;  
        success = SCNetworkReachabilityGetFlags(reachability, &flags);  
        _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);  
        CFRelease(reachability);  
    }  
    return _isDataSourceAvailable;
}

@end
