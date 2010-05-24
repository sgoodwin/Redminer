//
//  GOLogger.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/23/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "GOLogger.h"


@implementation GOLogger

+ (NSString*)loggerName{
	return @"GOUpdateText";
}

+ (void)log:(NSString*)string{
	[[NSNotificationCenter defaultCenter] postNotificationName:[self loggerName] object:string];
}
@end
