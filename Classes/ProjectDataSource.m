//
//  ProjectDataSource.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/20/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "ProjectDataSource.h"
#import "Issue.h"
#import "Journal.h"
#import "RedMineSupport.h"
#import "IssueCell.h"
#import "ProjectCell.h"

@implementation ProjectDataSource
@synthesize issues = _issues;
@synthesize activity = _activty;
@synthesize source = _source;
@synthesize segments = _segments;
@synthesize support = _support;
@synthesize projects = _projects;
@synthesize selectedProject = _selectedProject;
@synthesize projectTable = _projectTable;
@synthesize issueTable = _issueTable;
@synthesize textField = _textField;


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
	if(aTableView == self.projectTable){
		return [[self projects] count];
	}
	switch([[self segments] selectedSegment]){
		case RedmineActivity:
			NSLog(@"Showing Activities");
			return [[self activity] count];
			break;
		case RedmineIssues:
			NSLog(@"Showing Issues");
			return [[self currentIssues] count];
			break;
		default:
			NSLog(@"Polly should not be!");
			return 0;
			break;
	}
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
	if(aTableView == self.projectTable){
		return [[self projects] objectAtIndex:rowIndex];
	}
	switch ([[self segments] selectedSegment]){
		case RedmineActivity:
			return [[self activity] objectAtIndex:rowIndex];
			break;
		case RedmineIssues:
			return [[self currentIssues] objectAtIndex:rowIndex];
			break;
		default:
			NSLog(@"This should never happen!");
			return nil;
			break;
	}
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
	if(tableView == self.projectTable){
		return [[ProjectCell alloc] initTextCell:@"Change me"];
	}
	switch([[self segments] selectedSegment]){
		case RedmineIssues:
			return [[IssueCell alloc] initTextCell:@"change me"];
			break;
		case RedmineActivity:
			return [[NSCell alloc] initTextCell:@"Change me"];
			break;
		default:
			return [[NSCell alloc] initTextCell:@"Polly should not be!"];
			break;
	}
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex{
	if(aTableView == [self issueTable]){
		[self.textField setStringValue:[[[self currentIssues] objectAtIndex:rowIndex] desc]];
		return YES;
	}
	
	Project *p = [[self projects] objectAtIndex:rowIndex];
	self.selectedProject = p;
	[[self issues] setValue:[[self support] issuesInProject:p] forKey:[p name]];
	[[self issueTable] reloadData];
	return YES;
}

#pragma mark -
#pragma mark Actual Data:
- (RedMineSupport*)support{
	if(!_support){
		_support = [[RedMineSupport alloc] init];
		_support.key = @"7ded331bf46dbd35a351dbd4b861cbca09aa7cb0";
		_support.host = @"67.23.14.25/redmine";
	}
	return _support;
}

- (NSMutableDictionary*)issues{
	if(!_issues){
		self.issues = [[NSMutableDictionary dictionaryWithCapacity:1] retain];
	}
	return _issues;
}

- (NSArray *)currentIssues{
	NSArray *array = [[self issues] valueForKey:[[self selectedProject] name]];
	if(!array){
		return [NSArray array];
	}
	return array;
}

- (NSArray*)projects{
	if(!_projects){
		self.projects = [[self support] projects];
	}
	return _projects;
}


- (NSArray*)activity{
	if(!_activity){
		self.activity = [[self support] activity];
	}
	return _activity;
}
@end