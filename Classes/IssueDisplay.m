//
//  IssueDisplay.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/24/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "IssueDisplay.h"
#import "Issue.h"

@interface IssueDisplay(PrivateMethods)
- (void)commonInit;
@end

@implementation IssueDisplay
@synthesize currentIssue = _currentIssue;
@synthesize textBox = _textBox;

- (id)initWithFrame:(NSRect)frame {
	NSLog(@"init with frame!");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		[self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	NSLog(@"Init with coder!");
	self = [super initWithCoder:aDecoder];
	if(self){
		[self commonInit];
	}
	return self;
}

- (void)commonInit{
	[[self textBox] setStringValue:[[self currentIssue] description]];
}

- (void)setCurrentIssue:(Issue *)i{
	[_currentIssue release];
	_currentIssue = nil;
	_currentIssue = [i retain];
	[[self textBox] setStringValue:[[self currentIssue] description]];
}

/*- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
}*/

@end
