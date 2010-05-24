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
	[[self support] addObserver:self forKeyPath:@"issues" options:NSKeyValueObservingOptionNew context:nil];
	[[self support] addObserver:self forKeyPath:@"projects" options:NSKeyValueObservingOptionNew context:nil];
	
	dispatch_queue_t a_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);;
	dispatch_async(a_queue, ^{
		[[self support] refresh];
	});
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	if([keyPath isEqualToString:@"issues"])
		[[self issueTable] reloadData];
	if([keyPath isEqualToString:@"projects"])
		[[self outlineView] reloadData];
}

- (NSString*)errorMessage{
	return @"Polly should not be!";
}

- (NSString *)labelForSource:(RedmineDataSource)source{
	switch(source){
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
			return [[[self currentIssues] objectAtIndex:rowIndex] subject];
			break;
		case RedmineNewest:
			return [[[self currentNewest] objectAtIndex:rowIndex] subject];
			break;
		default:
			return nil;
			break;
	}
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
	Issue *i;
	switch([self type]){
		case RedmineIssues:
			i = [[self currentIssues] objectAtIndex:row];
			NSLog(@"selected issue: %@", i);
			[i setUpdatedValue:NO];
			[[self textField] setStringValue:[i desc]];
			[[self support] getInfoForIssue:i];
			break;
		case RedmineNewest:
			i = [[self currentNewest] objectAtIndex:row];
			NSLog(@"selected issue: %@", i);
			[i setUpdatedValue:NO];
			[[self textField] setStringValue:[i desc]];
			[[self support] getInfoForIssue:i];
			break;
		default:
			break;
	}
	NSError* err= nil;
	[[self moc] save:&err];
	if(!!err){
		NSLog(@"error saving updatedValue:%@", [err localizedDescription]);
	}
	return YES;
}

#pragma mark -
#pragma mark Outline methods

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
	if([[self labelForSource:RedmineIssues] isEqualToString:item]){
		self.type = RedmineIssues;
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
	if(!!item) return 1;
	
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
	if(!!item && [item isKindOfClass:[Project class]]){
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
	NSArray *newest = [[self support] updatedIssuesInProject:[self selectedProject]];
	NSLog(@"Updated items: %d", (int)[newest count]);
	return newest;
}

- (NSArray*)projects{
	return [[self support] projects];
}

- (NSManagedObjectContext*)moc{
	if(!_moc)
		[self setMoc:[CoreDataVendor newManagedObjectContext]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeMoc:) name:NSManagedObjectContextDidSaveNotification object:[[self support] moc]];
	return _moc;
}

- (void)mergeMoc:(NSNotification*)notification{
	[[self moc] mergeChangesFromContextDidSaveNotification:notification];
	[[self outlineView] reloadData];
	[[self issueTable] reloadData];
}
@end