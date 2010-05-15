//
//  JSONFriendly.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/15/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol JSONFriendly
+ (id)fromJSONDictionary:(NSDictionary*)jsonDict;
@end
