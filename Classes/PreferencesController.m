//
//  PreferencesController.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/25/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "PreferencesController.h"
#import "IssueDisplayView.h"

@implementation PreferencesController
static PreferencesController *sharedPrefs = nil;
@synthesize css_file_picker = _css_file_picker;
@synthesize issueDisplay = _issueDisplay;

+ (PreferencesController*)sharedPrefsWindowController{
	if(!sharedPrefs){
		sharedPrefs = [[PreferencesController alloc] initWithWindowNibName:@"Preferences"];
	}
	return sharedPrefs;
}

- (void)windowDidLoad{
	NSLog(@"Prefs loaded!");
	[[self css_file_picker] removeAllItems];
	NSArray *themes = [[NSBundle mainBundle] pathsForResourcesOfType:@"css" inDirectory:nil];
    for (NSString *theme in themes) {
        // Get theme name without file-extension
        NSString *themeName = [theme lastPathComponent];
        NSRange dotRange = [themeName rangeOfString:@"."];
        if (dotRange.location != NSNotFound) {
            themeName = [themeName substringToIndex:dotRange.location];
        }
        
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:themeName 
                                                          action:@selector(update:) 
                                                   keyEquivalent:@""];
        [menuItem setTarget:self];
        [menuItem setRepresentedObject:[theme lastPathComponent]];
		NSString *css_file_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"css_file"];
        if ([themeName isEqualToString:css_file_name]) {
            [menuItem setState:NSOnState];
        }
        [[self.css_file_picker menu] addItem:menuItem];
		if ([themeName isEqualToString:css_file_name]) {
            [self.css_file_picker selectItem:menuItem];
        }
		[menuItem release];
    }
}

- (NSString *)access_key{
	NSString* key = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_key"];
	if(!key){
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Missing your Redmine access key!"];
		[alert runModal];
		[alert release];
	}
	return key;
}

- (NSString *)server_location{
	NSString *loc = [[NSUserDefaults standardUserDefaults] valueForKey:@"server_location"];
	if(!loc){
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Missing your Redmine server location!"];
		[alert runModal];
		[alert release];
	}
	return loc;
}

- (NSString *)css_file{	
	NSString *fileName = @"default";
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"css_file"]){
		fileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"css_file"];
	}
	NSLog(@"filename: %@", fileName);
	NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"css"];
	return path;
}

- (void)update:(NSMenuItem*)sender{
	NSLog(@"new css file: %@", sender);
	[[NSUserDefaults standardUserDefaults] setObject:[sender title] forKey:@"css_file"];
	[[self issueDisplay] reloadIssue];
}
@end
