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
#import "Journal.h"
#import "RedMineSupport.h"
#import "IssueCell.h"
#import "ProjectCell.h"
#import "CoreDataVendor.h"

@interface ProjectDataSource(PrivateMethods)
- (NSString *)errorMessage;
- (NSString *)labelForSource:(RedmineDataSource)source;
@end

@implementation ProjectDataSource
@synthesize issues = _issues;
@synthesize activity = _activty;
@synthesize type = _type;
@synthesize support = _support;
@synthesize projects = _projects;
@synthesize selectedProject = _selectedProject;
@synthesize textField = _textField;
@synthesize outlineView = _outlineView;
@synthesize issueTable = _issueTable;
@synthesize moc = _moc;

- (IBAction)refresh:(id)sender{
	[[self support] refresh];
	[self.issueTable reloadData];
	[self.outlineView reloadData];
	NSLog(@"journals: %@", [Journal fetchAllJournals:[self moc]]);
}

- (NSString*)errorMessage{
	return @"Polly should not be!";
}

- (NSString *)labelForSource:(RedmineDataSource)source{
	switch(source){
		case RedmineActivity:
			return @"Activity";
			break;
		case RedmineIssues:
			return @"Issues";
			break;
		case RedmineNewest:
			return @"Newest";
			break;
		default:
			return [self errorMessage];
			break;
	}
}

#pragma mark -
#pragma mark Table methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
	switch([self type]){
		case RedmineIssues:
			return [[self currentIssues] count];
			break;
		case RedmineActivity:
			return [[self currentActivity] count];
			break;
		case RedmineNewest:
			return [[self currentNewest] count];
			break;
		default:
			return 0;
			break;
	}
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
	switch([self type]){
		case RedmineIssues:
			NSLog(@"currentIssues: %@", [self currentIssues]);
			return [[[self currentIssues] objectAtIndex:rowIndex] subject];
			break;
		case RedmineActivity:
			NSLog(@"currentActivity: %@", [self currentActivity]);
			return [[[self currentActivity] objectAtIndex:rowIndex] journalType];
			break;
		case RedmineNewest:
			return [[self currentNewest] objectAtIndex:rowIndex];
			break;
		default:
			return nil;
			break;
	}
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
	Issue *i;
	Journal *j;
	switch([self type]){
		case RedmineIssues:
			i = [[self currentIssues] objectAtIndex:row];
			[[self textField] setStringValue:[i desc]];
			break;
		case RedmineActivity:
			j = [[self currentActivity] objectAtIndex:row];
			[[self textField] setStringValue:[j notes]];
			break;
		case RedmineNewest:
			[[self textField] setStringValue:@"newest"];
			break;
		default:
			break;
	}
	return YES;
}

#pragma mark -
#pragma mark Outline methods

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
	if([[self labelForSource:RedmineIssues] isEqualToString:item]){
		self.type = RedmineIssues;
	}else if([[self labelForSource:RedmineActivity] isEqualToString:item]){
		self.type = RedmineActivity;
	}else{
		self.type = RedmineNewest;
	}
	
	id parent = [outlineView parentForItem:item];
	if(!!parent){
		Project *p = [Project projectWithName:parent inManagedObjectContext:[self moc]];
		[self setSelectedProject:p];
		NSLog(@"Selected project: %@", p);
	}else{
		NSLog(@"item :%@", item);
		Project *p = [Project projectWithName:item inManagedObjectContext:[self moc]];
		[self setSelectedProject:p];
		NSLog(@"Selected project: %@", p);
	}
	
	[[self issueTable] reloadData];
	return YES;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
	if(!item){
		Project *p = [[self projects] objectAtIndex:index];
		NSString *name = [p name];
		return name;
	}
	
	return [self labelForSource:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
	if([(NSString*) item isEqualToString:@"Activity"] || [(NSString*) item isEqualToString:@"Issues"])
	   return NO;
	return YES;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
	if(!!item) return 2;
	
	return [[self projects] count];
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item{
	if([item isKindOfClass:[NSString class]])
		return 20.0f;
	return 20.0f;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
	[[self projects] count];
	return item;
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
	if([item isKindOfClass:[Project class]]){
		return [[ProjectCell alloc] initTextCell:@"Change Me"];
	}
	return [[NSCell alloc] initTextCell:@"Change Me"];
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

- (NSArray *)currentIssues{
	if(![self selectedProject]){
		NSLog(@"No project yet");
		return [NSArray array];
	}
	[[self moc] refreshObject:[self selectedProject] mergeChanges:YES];
	
	NSArray *array = [[[self selectedProject] issues] allObjects];
	if(!array){
		return [NSArray array];
	}
	return array;
}

- (NSArray *)currentNewest{
	return [NSArray arrayWithObjects:@"Latest", @"And", @"Greatest", nil];
}

- (NSArray *)currentActivity{
	if(![self selectedProject]){
		NSLog(@"No project yet");
		return [NSArray array];
	}
	[[self moc] refreshObject:[self selectedProject] mergeChanges:YES];
	
	NSArray *array = [[[self selectedProject] activity] allObjects];
	if(!array){
		return [NSArray array];
	}
	return array;
}

- (NSArray*)projects{
	return [[self support] projects];
}


- (NSArray*)activity{
	return [[self support] activity];
}

- (NSManagedObjectContext*)moc{
	if(!_moc)
		[self setMoc:[CoreDataVendor newManagedObjectContext]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeMoc:) name:NSManagedObjectContextDidSaveNotification object:[[self support] moc]];
	return _moc;
}

- (void)mergeMoc:(NSNotification*)notification{
	NSLog(@"merging!");
	[[self moc] mergeChangesFromContextDidSaveNotification:notification];
	[[self outlineView] reloadData];
	[[self issueTable] reloadData];
}
@end