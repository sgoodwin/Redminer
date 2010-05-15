//
//  Activity.m
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/15/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import "Activity.h"


@implementation Activity

+ (id)fromJSONDictionary:(NSDictionary *)jsonDict{
	Activity *p = [[Activity alloc] init];
	NSLog(@"Activity Dictionary: %@", jsonDict);
	return p;
}

@end
