//
//  RedminerAppDelegate.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RedMineSupport;
@interface RedminerAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	
	NSSegmentedControl *_segmentControl;
	NSTableView *_issueTable;
	NSTableView *_projectTable;
	NSTextField *_textField;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSSegmentedControl *segmentControl;
@property (assign) IBOutlet NSTableView *issueTable;
@property (assign) IBOutlet NSTableView *projectTable;
@property (assign) IBOutlet NSTextField *textField;

- (IBAction)segmentControlClicked:(id)sender;
@end
