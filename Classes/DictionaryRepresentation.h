//
//  DictionaryRepresentation.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/24/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kNameKey @"name"
#define kDescKey @"desc"
#define kIDKey @"id"
#define kSubjectKey @"subject"
#define kdDoneRatioKey @"done_ratio"
#define kItemCountKey @"item_count"

@protocol DictionaryRepresentation
- (NSDictionary*)dictVersion:(NSManagedObjectContext*)moc_;
@end