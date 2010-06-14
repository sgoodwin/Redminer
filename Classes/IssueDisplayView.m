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
	Issue *i = (Issue*)[[self moc] objectWithID:[self currentIssueID]];
	[[self mainFrame] loadHTMLString:[i htmlString] baseURL:nil];
}

- (void)setCurrentIssue:(IssueID*)i {
	NSLog(@"New issue: %@", i);
	
	[_currentIssueID release];
	_currentIssueID = nil;
	_currentIssueID = [i retain];
	
	Issue *issue = (Issue*)[[self moc] objectWithID:[self currentIssueID]];
	[[self mainFrame] loadHTMLString:[issue htmlString] baseURL:nil];
}

@end