//
//  DictionaryRepresentation.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/24/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kNameKey @"name"
#define kUpdatedCountKey @"updatedCount"

@protocol DictionaryRepresentation
- (NSDictionary*)dictVersion:(NSManagedObjectContext*)moc_;
@end