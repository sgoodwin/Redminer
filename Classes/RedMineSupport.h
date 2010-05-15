//
//  RedMineSupport.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Project;
@interface RedMineSupport : NSObject{
	NSString *key;
	NSString *host;
	NSMutableData *_data;
}
@property(nonatomic, retain) NSString *key;
@property(nonatomic, retain) NSString *host;

- (NSArray*)issues;
- (NSArray*)projects;
- (NSArray*)news;
- (NSArray*)activity;
- (NSArray*)issuesInProject:(Project*)project;
@end
