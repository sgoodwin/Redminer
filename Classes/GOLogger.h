//
//  GOLogger.h
//  Redminer
//
//  Created by Samuel Ryan Goodwin on 5/23/10.
//  Copyright 2010 Goodwinlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GOLogger : NSObject {

}

+ (NSString*)loggerName;
+ (void)log:(NSString*)string;
@end
