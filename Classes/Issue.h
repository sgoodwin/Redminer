//
//  Issue.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/13/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "_Issue.h"

@class Project;
@interface Issue : _Issue{
	NSSet *_undefined_keys;
}

+ (void)checkIssue:(Issue*)i ForDups:(NSManagedObjectContext*)moc_;
@end
