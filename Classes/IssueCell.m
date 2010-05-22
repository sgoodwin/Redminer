//
//  CustomCell.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/20/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "IssueCell.h"
#import "Issue.h"

@implementation IssueCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor grayColor] endingColor:[NSColor darkGrayColor]];
	[gradient drawInRect:cellFrame angle:90.0f];
	
	[[NSColor whiteColor] set];
	
	Issue *issue = (Issue*)[self objectValue];
	
	NSArray *objects = [NSArray arrayWithObjects:[NSFont fontWithName:@"Ohlfs" size:12], [NSColor whiteColor],nil];
	NSArray *keys = [NSArray arrayWithObjects:NSFontAttributeName, NSForegroundColorAttributeName, nil];
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	NSRect subjectRect = NSInsetRect(cellFrame, 20.0f, 20.0f);
	[[issue subject] drawInRect:subjectRect withAttributes:dict];
	
	NSPoint donePoint = cellFrame.origin;
	donePoint.x += 10.0f;
	donePoint.y += cellFrame.size.height-20.0f;
	NSString *doneString = [NSString stringWithFormat:@"%@/100", [issue done_ratio]];
	[doneString drawAtPoint:donePoint withAttributes:dict];
	[gradient release];
	return;
}

@end
