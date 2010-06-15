//
//  IssueDisplayView.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 6/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "IssueDisplayView.h"
#import "Issue.h"
#import "CoreDataVendor.h"

@implementation IssueDisplayView
@synthesize currentIssueID = _currentIssueID;
@synthesize moc = _moc;

- (NSManagedObjectContext*)moc{
	if(!_moc){
		[self setMoc:[CoreDataVendor newManagedObjectContext]];
	}
	return _moc;
}

- (void)reloadIssue{
	if(![NSThread isMainThread]){
		[self performSelectorOnMainThread:@selector(reloadIssue) withObject:nil waitUntilDone:NO];
		return;
	}
	Issue *issue = [Issue issueWithID:[self currentIssueID] inManagedObjectContext:[self moc]];
	[[self mainFrame] loadHTMLString:[issue htmlString] baseURL:nil];
}

- (void)setCurrentIssueID:(NSNumber*)idnumber{	
	if(![NSThread isMainThread]){
		[self performSelectorOnMainThread:@selector(setCurrentIssueID:) withObject:idnumber waitUntilDone:NO];
		return;
	}

	
	[_currentIssueID release];
	_currentIssueID = nil;
	_currentIssueID = [idnumber retain];
	
	Issue *issue = [Issue issueWithID:idnumber inManagedObjectContext:[self moc]];
	[[self mainFrame] loadHTMLString:[issue htmlString] baseURL:nil];
}

@end