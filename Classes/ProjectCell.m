//
//  ProjectCell.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/21/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "ProjectCell.h"
#import "Project.h"

@implementation ProjectCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
	//NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor grayColor] endingColor:[NSColor darkGrayColor]];
	//[gradient drawInRect:cellFrame angle:90.0f];
	
	[[NSColor blackColor] set];
	
	Project *project = (Project*)[self objectValue];
	
	NSArray *objects = [NSArray arrayWithObjects:[NSFont fontWithName:@"Ohlfs" size:10], [NSColor blackColor],nil];
	NSArray *keys = [NSArray arrayWithObjects:NSFontAttributeName, NSForegroundColorAttributeName, nil];
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	NSRect subjectRect = NSInsetRect(cellFrame, 5.0f, 5.0f);
	[[project name] drawInRect:subjectRect withAttributes:dict];	
	return;
}

@end
