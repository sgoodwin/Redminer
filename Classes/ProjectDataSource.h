//
//  ProjectDataSource.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/20/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	RedmineActivity=0,
	RedmineIssues,
	RedmineProjects,
} RedmineDataSource;

@class RedMineSupport;
@class Project;
@interface ProjectDataSource : NSObject <NSTableViewDataSource, NSTableViewDelegate>{
	NSMutableDictionary *_issues;
	NSArray *_activity;
	NSArray *_projects;
	
	Project *_selectedProject;
	
	RedmineDataSource _source;
	RedMineSupport *_support;
	
	NSSegmentedControl *_segments;
	
	NSTableView *_projectTable;
	NSTableView *_issueTable;
	NSTextField *_textField;
}
@property(nonatomic, retain) NSMutableDictionary *issues;
- (NSArray *)currentIssues;
@property(nonatomic, retain) NSArray *activity;
@property(nonatomic, retain) NSArray *projects;

@property(nonatomic, retain) Project *selectedProject;

@property(nonatomic, assign) RedmineDataSource source;
@property(nonatomic, retain) RedMineSupport *support;

@property(nonatomic, retain) NSSegmentedControl *segments;
@property(nonatomic, retain) NSTableView *projectTable;
@property(nonatomic, retain) NSTableView *issueTable;
@property(nonatomic, retain) IBOutlet NSTextField *textField;
@end
