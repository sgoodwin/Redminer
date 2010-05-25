//
//  Project.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 ;. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "_Project.h"
#import "DictionaryRepresentation.h"

@interface Project : _Project<DictionaryRepresentation>{
	NSSet *_undefined_keys;
}

+ (Project*)projectWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (void)checkProject:(Project*)p ForDups:(NSManagedObjectContext*)moc_;
- (NSArray*)updatedIssues:(NSManagedObjectContext*)moc_;
@end
