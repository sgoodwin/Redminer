//
//  NSArrayAdditions.h
//  LifeLoc
//
//  Created by Samuel Goodwin on 3/23/10.
//  Copyright 2010 ID345. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Contact;
typedef id (^CollectBlock)(NSDictionary *value);
typedef id (^SelectBlock)(id value, id prev);

@interface NSArray  (ID345Additions)
- (NSArray *)collectWithBlock:(CollectBlock)block;
- (id)selectWithBlock:(SelectBlock)block;
+ (NSArray *)arrayThatCounts:(NSUInteger)count;
@end
