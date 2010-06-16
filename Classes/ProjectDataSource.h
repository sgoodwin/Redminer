//
//  ProjectDataSource.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/20/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IssueDisplayView;
@class Project;
@interface ProjectDataSource : NSObject <NSOutlineViewDelegate, NSOutlineViewDataSource>{
	NSMutableDictionary *_issues;
	NSArray *_projects;
	
	NSOutlineView *_outlineView;
	IssueDisplayView *_issueDisplay;
	
	NSManagedObjectContext *_moc;
	
	NSOperationQueue *_internetQueue;
}
@property(nonatomic, retain) NSMutableDictionary *issues;
@property(nonatomic, retain) NSArray *projects;

@property(nonatomic, retain) NSManagedObjectContext *moc;

@property(nonatomic, retain) IBOutlet IssueDisplayView *issueDisplay;
@property(nonatomic, retain) IBOutlet NSOutlineView *outlineView;

@property(nonatomic, retain) NSOperationQueue *internetQueue;

- (IBAction)refresh:(id)sender;
- (void)reload:(NSNotification*)sender;

- (void)save;
-  (IBAction)markAllAsRead:(id)sender;
@end
