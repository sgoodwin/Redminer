//
//  RedMineSupport.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Project;
@class Issue;
@class Note;
@interface RedMineSupport : NSObject<NSXMLParserDelegate>{
	NSMutableData *_data;
	
	NSManagedObjectContext *_moc;
	
	Issue *_currentIssue;
	Project *_currentProject;
	Note *_currentNote;
	
	NSString *_keyInProgress;
	NSMutableString *_textInProgress;
}
@property(nonatomic, retain) NSManagedObjectContext *moc;

@property(nonatomic, retain) Issue *currentIssue;
@property(nonatomic, retain) Project *currentProject;
@property(nonatomic, retain) Note *currentNote;

@property(nonatomic, retain) NSString *keyInProgress;
@property(nonatomic, retain) NSMutableString *textInProgress;

- (NSArray*)issues;
- (NSArray*)projects;
- (NSArray*)issuesInProject:(Project*)project;
- (NSArray*)updatedIssuesInProject:(Project*)project;

- (void)getIssuesInProject:(Project*)project;
- (void)getInfoForIssue:(Issue*)i;

- (void)refresh;

+ (BOOL)hostIsReachable;
@end
