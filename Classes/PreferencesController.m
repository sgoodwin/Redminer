//
//  PreferencesController.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/25/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "PreferencesController.h"


@implementation PreferencesController
static PreferencesController *sharedPrefs = nil;
@synthesize css_box = _css_box;

+ (PreferencesController*)sharedPrefsWindowController{
	if(!sharedPrefs){
		sharedPrefs = [[PreferencesController alloc] initWithWindowNibName:@"Preferences"];
	}
	return sharedPrefs;
}

- (void)windowDidLoad{
	NSLog(@"Prefs loaded!");
	[[self css_box] setString:[self css_file]];
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
	if(NO && [[NSUserDefaults standardUserDefaults] objectForKey:@"css_file"]){
		NSLog(@"Returning stored css file");
		return [[NSUserDefaults standardUserDefaults] objectForKey:@"css_file"];
	}else{
		NSLog(@"Returning default css file");
		NSString *path = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"css"];
		NSError *err = nil;
		NSString *css = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
		if(nil == css){
			NSLog(@"failed to load default css file: %@", [err localizedDescription]);
		}
		[[NSUserDefaults standardUserDefaults] setObject:css forKey:@"css_file"];
		return css;
	}
}

#pragma mark -
#pragma mark NSTextViewDelegat methods

- (BOOL)textView:(NSTextView *)aTextView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString{
	NSLog(@"Changing characters!");
	return YES;
}

@end
