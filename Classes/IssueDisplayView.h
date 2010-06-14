//
//  IssueDisplayView.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 6/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class Issue;
@interface IssueDisplayView : WebView {
	Issue *_currentIssue;
}
@property(nonatomic, retain) Issue *currentIssue;

- (void)setCurrentIssue:(Issue*)i;
@end
