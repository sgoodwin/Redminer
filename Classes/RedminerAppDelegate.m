//
//  RedminerAppDelegate.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "RedminerAppDelegate.h"
#import "RedMineSupport.h"
#import "Project.h"

@implementation RedminerAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	_miner = [[RedMineSupport alloc] init];
	_miner.key = @"7ded331bf46dbd35a351dbd4b861cbca09aa7cb0";
	_miner.host = @"67.23.14.25/redmine";
	
	[_miner issues];
	//[_miner projects];
	//[_miner news];
	//[_miner activity];
	//Project *p = [[Project alloc] init];
	//p.id = [NSNumber numberWithInt:1];
	//[_miner issuesInProject:p];
	//[_miner users];
}

@end
