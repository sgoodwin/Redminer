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
	NSString *_key;
	NSString *_host;
	NSMutableData *_data;
	
	NSManagedObjectContext *_moc;
}
@property(nonatomic, retain) NSString *key;
@property(nonatomic, retain) NSString *host;
@property(nonatomic, retain) NSManagedObjectContext *moc;

- (NSArray*)issues;
- (NSArray*)projects;
- (NSArray*)news;
- (NSArray*)activity;
- (NSArray*)issuesInProject:(Project*)project;
- (NSArray*)users;

- (void)getIssuesInProject:(Project*)project;

- (void)refresh;
@end
