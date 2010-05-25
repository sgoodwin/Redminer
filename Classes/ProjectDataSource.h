//
//  ProjectDataSource.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/20/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	RedmineIssues=0,
	RedmineNewest,
} RedmineDataSource;

@class RedMineSupport;
@class IssueDisplay;
@class Project;
@interface ProjectDataSource : NSObject <NSOutlineViewDelegate, NSOutlineViewDataSource, NSTableViewDelegate, NSTableViewDataSource>{
	NSMutableDictionary *_issues;
	NSArray *_activity;
	NSArray *_projects;
	
	Project *_selectedProject;
	
	RedmineDataSource _type;
	RedMineSupport *_support;
	
	NSOutlineView *_outlineView;
	NSTableView *_issueTable;
	IssueDisplay *_issueDisplay;
	
	NSManagedObjectContext *_moc;
}
@property(nonatomic, retain) NSMutableDictionary *issues;
- (NSArray *)currentIssues;
- (NSArray *)currentNewest;
@property(nonatomic, retain) NSArray *activity;
@property(nonatomic, retain) NSArray *projects;

@property(nonatomic, retain) Project *selectedProject;

@property(nonatomic, assign) RedmineDataSource type;
@property(nonatomic, retain) RedMineSupport *support;

@property(nonatomic, retain) NSManagedObjectContext *moc;

@property(nonatomic, retain) IBOutlet IssueDisplay *issueDisplay;
@property(nonatomic, retain) IBOutlet NSOutlineView *outlineView;
@property(nonatomic, retain) IBOutlet NSTableView *issueTable;

- (IBAction)refresh:(id)sender;
@end
