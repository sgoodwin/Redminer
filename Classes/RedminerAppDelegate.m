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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (IBAction)openPreferencesWindow:(id)sender {
	[[PreferencesController sharedPrefsWindowController] showWindow:nil];
}
@end
