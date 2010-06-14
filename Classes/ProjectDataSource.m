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
@end

@implementation ProjectDataSource
@synthesize issues = _issues;
@synthesize projects = _projects;
@synthesize issueDisplay = _issueDisplay;
@synthesize outlineView = _outlineView;
@synthesize moc = _moc;

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
	[[NSOperationQueue mainQueue] addOperation:op];
}

- (NSString*)errorMessage{
	return @"Polly should not be!";
}

#pragma mark -
#pragma mark Outline methods

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{	
	NSLog(@"Selected item: %@", item);
	if([item valueForKey:kDescKey]){
		Issue *i = [Issue issueWithID:[item valueForKey:kIDKey] inManagedObjectContext:[self moc]];
		APIOperation *op = [APIOperation operationWithType:APIOperationIssueDetail andObjectID:i.objectID];
		[[NSOperationQueue mainQueue] addOperation:op];
		
		[[self issueDisplay] setCurrentIssue:i];
		RedminerAppDelegate *del = (RedminerAppDelegate*)[[NSApplication sharedApplication] delegate];
		[del setTitle:[i subject]];
		
		return YES;
	}
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
		return [[p issues] count];
	}
	return [[self projects] count];
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item{
	return 60.0f;
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

- (void)reload:(NSNotification*)sender{
	NSLog(@"Refreshing! %@", sender);
	if([[sender name] isEqualToString:kAPIOperationProjects] || [[sender name] isEqualToString:kAPIOperationIssues]){
		[self.outlineView reloadData];
	}
	
}
@end