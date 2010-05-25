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

+ (PreferencesController*)sharedPrefsWindowController{
	if(!sharedPrefs){
		sharedPrefs = [[PreferencesController alloc] initWithWindowNibName:@"Preferences" owner:self];
	}
	return sharedPrefs;
}

- (NSString *)access_key{
	NSString* key = [[NSUserDefaults standardUserDefaults] valueForKey:@"access_key"];
	if(!key){
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Missing your access key!"];
		[alert runModal];
		[alert release];
	}
	return key;
}

- (NSString *)server_location{
	NSString *loc = [[NSUserDefaults standardUserDefaults] valueForKey:@"server_location"];
	if(!loc){
		NSAlert *alert = [[NSAlert alloc] init];
		[alert setMessageText:@"Missing your server location!"];
		[alert runModal];
		[alert release];
	}
	return loc;
}
@end
