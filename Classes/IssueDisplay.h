//
//  IssueDisplay.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/24/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Issue;
@interface IssueDisplay : NSView {
	Issue *_currentIssue;
	NSTextField *_textBox;
}
@property(nonatomic, retain) Issue *currentIssue;
@property(nonatomic, retain) IBOutlet NSTextField *textBox;
@end
