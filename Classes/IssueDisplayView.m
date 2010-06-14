//
//  IssueDisplayView.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 6/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "IssueDisplayView.h"
#import "Issue.h"

@implementation IssueDisplayView
@synthesize currentIssue = _currentIssue;

- (void)setCurrentIssue:(Issue*)i {
	NSLog(@"New issue: %@", i);
	
	[_currentIssue release];
	_currentIssue = nil;
	_currentIssue = [i retain];
	[[self mainFrame] loadHTMLString:[i htmlString] baseURL:nil];
}

@end