//
//  SubCell.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/24/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "SubCell.h"
#import "Project.h"

@implementation SubCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
	//NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor grayColor] endingColor:[NSColor darkGrayColor]];
	//[gradient drawInRect:cellFrame angle:90.0f];
	
	[[NSColor blackColor] set];
	
	
	
	NSArray *objects = [NSArray arrayWithObjects:[NSFont fontWithName:@"Ohlfs" size:10], [NSColor blackColor],nil];
	NSArray *keys = [NSArray arrayWithObjects:NSFontAttributeName, NSForegroundColorAttributeName, nil];
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	NSRect subjectRect = NSIntegralRect(NSInsetRect(cellFrame, 5.0f, 5.0f));
	[[[self objectValue] valueForKey:kNameKey] drawInRect:subjectRect withAttributes:dict];	
	return;
}


@end
