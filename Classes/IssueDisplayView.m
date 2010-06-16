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
#import "PreferencesController.h"

@interface IssueDisplayView (PrivateMethods)
- (void)applyTheme;
@end

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
	NSLog(@"Reloading issue");
	Issue *issue = [Issue issueWithID:[self currentIssueID] inManagedObjectContext:[self moc]];
	[[self mainFrame] loadHTMLString:[issue htmlString] baseURL:nil];
	[self applyTheme];
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
	[self applyTheme];
}

- (void)applyTheme{	
    NSString *path = [[PreferencesController sharedPrefsWindowController] css_file];
	NSLog(@"Using css file: %@", path);
	if([[NSFileManager defaultManager] fileExistsAtPath:path]){
		[self setDrawsBackground:YES];
		WebPreferences *prefs = [WebPreferences standardPreferences];
		[prefs setUserStyleSheetEnabled:YES];
		[prefs setUserStyleSheetLocation:[NSURL fileURLWithPath:path]];
		[self setPreferences:prefs];
	}
}

@end