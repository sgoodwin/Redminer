//
//  RedminerAppDelegate.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "RedminerAppDelegate.h"
#import "CoreDataVendor.h"
#import "PreferencesController.h"

@implementation RedminerAppDelegate

@synthesize window = _window;
@synthesize outline = _outline;
@synthesize textField = _textField;
@synthesize issueDisplay = _issueDisplay;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[[self window] setTitle:@"Some stuff"];
}

- (IBAction)openPreferencesWindow:(id)sender {
	[[PreferencesController sharedPrefsWindowController] setIssueDisplay:[self issueDisplay]];
	[[PreferencesController sharedPrefsWindowController] showWindow:nil];
}

- (void)setTitle:(NSString*)title{
	[[self window] setTitle:title];
}

// Handle a file dropped on the dock icon
- (BOOL)application:(NSApplication *)sender openFile:(NSString *)path
{
	NSLog(@"file was dropped in! %@", path);
	NSString *dest = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[path lastPathComponent]];
	NSError *err = nil;
	BOOL success = [[NSFileManager defaultManager] copyItemAtPath:path toPath:dest error:&err];
	if(!success){
		NSLog(@"Failed to copy %@ to %@, %@", path, dest, [err localizedDescription]);
	}
	
	return YES;
}
@end
