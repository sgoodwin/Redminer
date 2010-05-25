//
//  PreferencesController.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/25/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferencesController : NSWindowController {

}

+ (PreferencesController*)sharedPrefsWindowController;
- (NSString *)access_key;
- (NSString *)server_location;
@end