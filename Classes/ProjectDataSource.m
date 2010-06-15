//
//  ProjectDataSource.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/20/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "ProjectDataSource.h"
#import "Issue.h"
#import "Project.h"
#import "DictionaryRepresentation.h"
#import "IssueCell.h"
#import "IssueDisplayView.h"
#import "ProjectCell.h"
#import "IssueCell.h"
#import "CoreDataVendor.h"
#import "RedminerAppDelegate.h"
#import "APIOperation.h"

@interface ProjectDataSource(PrivateMethods)
- (NSString *)errorMessage;
- (BOOL (^)(id obj, NSUInteger idx, BOOL *stop))projectTestingForName:(NSString*)name;
@end

@implementation ProjectDataSource
@synthesize issues = _issues;
@synthesize projects = _projects;
@synthesize issueDisplay = _issueDisplay;
@synthesize outlineView = _outlineView;
@synthesize moc = _moc;
@synthesize internetQueue = _internetQueue;

- (id)init{
	if((self = [super init])){
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:kAPIOperationProjects object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:kAPIOperationIssues object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:kAPIOperationIssue object:nil];
	}
	return self;
}

- (IBAction)refresh:(id)sender{
	APIOperation *op = [APIOperation operationWithType:APIOperationProjects andObjectID:nil];
	[[self internetQueue] addOperation:op];
}

- (NSString*)errorMessage{
	return @"Polly should not be!";
}

#pragma mark -
#pragma mark Outline methods

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{	
	if([item valueForKey:kDescKey]){
		Issue *i = [Issue issueWithID:[item valueForKey:kIDKey] inManagedObjectContext:[self moc]];
		APIOperation *op = [APIOperation operationWithType:APIOperationIssueDetail andObjectID:i.objectID];
		[[NSOperationQueue mainQueue] addOperation:op];
		
		[[self issueDisplay] setCurrentIssueID:i.id];
		RedminerAppDelegate *del = (RedminerAppDelegate*)[[NSApplication sharedApplication] delegate];
		[del setTitle:[i subject]];
		
		return YES;
	}
	
	Project *p = [Project projectWithName:[item valueForKey:kNameKey] inManagedObjectContext:[self moc]];
	APIOperation *op = [APIOperation operationWithType:APIOperationIssuesInProject andObjectID:[p objectID]];
	[[NSOperationQueue mainQueue] addOperation:op];
	return YES;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
	if(nil == item){
		Project *p = [[self projects] objectAtIndex:index];
		return [p dictVersion:[self moc]];
	}
	
	Project *p = [Project projectWithName:[item valueForKey:kNameKey] inManagedObjectContext:[self moc]];
	Issue *i = [[p sortedIssues] objectAtIndex:index];
	return [i dictVersion:[self moc]];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
	if([item valueForKey:kDescKey]){
		return NO;
	}
	return YES;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
	if(item){
		Project *p = [Project projectWithName:[item valueForKey:kNameKey] inManagedObjectContext:[self moc]];
		return [[p sortedIssues] count];
	}
	return [[self projects] count];
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item{
	//if(item && [item valueForKey:kNameKey])
		return 30.0f;
	//return 60.0f;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
	return item;
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
	if([item valueForKey:kDescKey])
		return [[[IssueCell alloc] initTextCell:@"Change Me"] autorelease];
	
	return [[[ProjectCell alloc] initTextCell:@"Change Me"] autorelease];
}

#pragma mark -
#pragma mark Actual Data:

- (NSOperationQueue*)internetQueue{
	if(_internetQueue)
		return _internetQueue;
	
	_internetQueue = [[NSOperationQueue alloc] init];
	[_internetQueue setName:@"internets"];
	[_internetQueue setMaxConcurrentOperationCount:1];
	return _internetQueue;
}

- (NSArray*)projects{
	return [Project fetchAllProjects:[self moc]];
}

- (NSManagedObjectContext*)moc{
	if(!_moc){
		[self setMoc:[CoreDataVendor newManagedObjectContext]];
	}
	return _moc;
}

- (void)mergeMoc:(NSNotification*)notification{
	[[self moc] mergeChangesFromContextDidSaveNotification:notification];
	[self performSelectorOnMainThread:@selector(reload:) withObject:nil waitUntilDone:NO];
}

- (BOOL (^)(id obj, NSUInteger idx, BOOL *stop))projectTestingForName:(NSString*)name {
    return [[^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj objectForKey:kNameKey] isEqualToString:name]) {
			*stop = YES;
			return YES;
        }
        return NO;
    } copy] autorelease];
}

- (void)reload:(NSNotification*)sender{
	if([[sender name] isEqualToString:kAPIOperationProjects]){
		[self.outlineView reloadData];
		return;
	}
	
	if([[sender name] isEqualToString:kAPIOperationIssues]){
		// Reload only the index with the project we got new data for.
		if([sender object]){
			NSInteger index = [[self projects] indexOfObjectPassingTest:[self projectTestingForName:[sender object]]];
			[self.outlineView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
		}else{
			[self.outlineView reloadData];
		}
	}
	
	if([[sender name] isEqualToString:kAPIOperationIssue]){
		[[self issueDisplay] reloadIssue];
	}
}
@end