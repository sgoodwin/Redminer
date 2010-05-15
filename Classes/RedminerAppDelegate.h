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
	RedMineSupport *_miner;
}

@property (assign) IBOutlet NSWindow *window;

@end
