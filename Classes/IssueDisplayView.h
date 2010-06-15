//
//  IssueDisplayView.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 6/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class IssueID;
@interface IssueDisplayView : WebView {
	NSNumber *_currentIssueID;
	
	NSManagedObjectContext *_moc;
}
@property(nonatomic, retain) NSNumber *currentIssueID;
@property(nonatomic, retain) NSManagedObjectContext *moc;

- (void)setCurrentIssueID:(NSNumber*)idnumber;
- (void)reloadIssue;
@end
