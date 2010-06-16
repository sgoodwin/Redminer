//
//  PreferencesController.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/25/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IssueDisplayView;
@interface PreferencesController : NSWindowController<NSTextViewDelegate>{
	NSPopUpButton *_css_file_picker;
	IssueDisplayView *_issueDisplay;
}
@property(nonatomic, retain) IBOutlet NSPopUpButton *css_file_picker;
@property(nonatomic, assign) IssueDisplayView *issueDisplay;

+ (PreferencesController*)sharedPrefsWindowController;
- (NSString *)access_key;
- (NSString *)server_location;
- (NSString *)css_file;
- (NSArray *)css_files;
@end