//
//  APIOperation.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 6/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	APIOperationProjects=0,
	APIOperationIssuesInProject,
	APIOperationIssueDetail
} APIOperationType;

#define kAPIOperationProjects @"operation_projects"
#define kAPIOperationIssues @"operation_issues"
#define kAPIOperationIssue @"operation_issue"

@class ProjectID;
@class IssueID;
@class Issue;
@class Project;
@class Note;

@protocol APIOperationDelegate
- (void)finishedLoadingOperation;
@end

@interface APIOperation : NSOperation <NSXMLParserDelegate>{
	IssueID *_issueID;
	ProjectID *_projectID;
	APIOperationType type;
	
	NSMutableData *_data;
	
	NSManagedObjectContext *_moc;
	
	Issue *_currentIssue;
	Project *_currentProject;
	Note *_currentNote;
	
	BOOL _finished;
	BOOL _executing;
	
	NSString *_keyInProgress;
	NSMutableString *_textInProgress;
}
@property(nonatomic, retain)IssueID *issueID;
@property(nonatomic, retain)ProjectID *projectID;
@property(nonatomic, assign)APIOperationType type;

@property(nonatomic, retain) NSManagedObjectContext *moc;
@property(nonatomic, retain) Issue *currentIssue;
@property(nonatomic, retain) Project *currentProject;
@property(nonatomic, retain) Note *currentNote;
@property(nonatomic, retain) NSString *keyInProgress;
@property(nonatomic, retain) NSMutableString *textInProgress;


+ (APIOperation *)operationWithType:(APIOperationType)type andObjectID:(NSManagedObjectID*)object_id;
+ (NSString*)nameForType:(APIOperationType)aType;
@end

