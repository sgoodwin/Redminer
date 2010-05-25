//
//  RedminerAppDelegate.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RedminerAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *_window;
	
	NSOutlineView *_outline;
	NSTextField *_textField;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSOutlineView *outline;
@property (assign) IBOutlet NSTextField *textField;

- (IBAction)openPreferencesWindow:(id)sender;
@end
