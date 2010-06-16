//
//  CustomCell.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/20/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "IssueCell.h"
#import "Issue.h"
#import "DictionaryRepresentation.h"

@implementation IssueCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView{
	//NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor grayColor] endingColor:[NSColor darkGrayColor]];
//	[gradient drawInRect:cellFrame angle:90.0f];
//	
//	[[NSColor whiteColor] set];
	
	NSArray *objects = [NSArray arrayWithObjects:[NSFont fontWithName:@"Arial Black" size:10.0f], [NSColor blackColor],nil];
	NSArray *keys = [NSArray arrayWithObjects:NSFontAttributeName, NSForegroundColorAttributeName, nil];
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	NSRect subjectRect = NSIntegralRect(NSInsetRect(cellFrame, 5.0f, 5.0f));
	NSRect countRect = NSIntegralRect(NSMakeRect(cellFrame.origin.x+cellFrame.size.width-50.0f, cellFrame.origin.y+5.0f, subjectRect.size.width, subjectRect.size.height));
	[[[self objectValue] valueForKey:kSubjectKey] drawInRect:subjectRect withAttributes:dict];	
	NSString *doneRatio = [NSString stringWithFormat:@"%@%%", [[[self objectValue] valueForKey:kdDoneRatioKey] stringValue]];
	[doneRatio drawInRect:countRect withAttributes:dict];
	return;
}

@end
