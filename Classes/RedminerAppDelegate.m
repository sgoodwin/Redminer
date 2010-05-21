//
//  RedminerAppDelegate.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "RedminerAppDelegate.h"
#import "ProjectDataSource.h"

@implementation RedminerAppDelegate

@synthesize window;
@synthesize segmentControl = _segmentControl;
@synthesize projectTable = _projectTable;
@synthesize issueTable = _issueTable;
@synthesize textField = _textField;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[[self.segmentControl cell] setTrackingMode:NSSegmentSwitchTrackingSelectOne];
	[[self.segmentControl cell] setControlSize:NSRegularControlSize];
	[self.segmentControl setTarget:self];
    [self.segmentControl setAction:@selector(segmentControlClicked:)];
	 
	
	ProjectDataSource *source = [[ProjectDataSource alloc] init];
	source.segments = [self segmentControl];
	source.issueTable = [self issueTable];
	source.projectTable = [self projectTable];
	source.textField = [self textField];
	
	[[self projectTable] setDataSource:source];
	[[self projectTable] setDelegate:source];
	[[self projectTable] reloadData];
	
	[[self issueTable] setDataSource:source];
	[[self issueTable] setDelegate:source];
	[[self issueTable] reloadData];
}

- (IBAction)segmentControlClicked:(id)sender{
	[[self issueTable] reloadData];
}
@end
