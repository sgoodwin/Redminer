//
//  StatusLabel.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/23/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "StatusLabel.h"
#import "GOLogger.h"

@implementation StatusLabel

- (id)initWithCoder:(NSCoder *)aDecoder{
	if((self = [super initWithCoder:aDecoder])){
		[self setStringValue:@"Created from coder!"];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateText:) name:[GOLogger loggerName] object:nil];
	}
	return self;
}

- (void)updateText:(NSNotification*)aNotification{
	[self setStringValue:[aNotification object]];
}
@end
