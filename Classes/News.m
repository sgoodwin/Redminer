//
//  News.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/15/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "News.h"


@implementation News

+ (id)fromJSONDictionary:(NSDictionary *)jsonDict{
	News *p = [[[self class] alloc] init];
	NSLog(@"News Dictionary: %@", jsonDict);
	return p;
}

@end
