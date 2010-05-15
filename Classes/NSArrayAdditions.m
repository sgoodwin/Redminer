//
//  NSArrayAdditions.m
//  LifeLoc
//
//  Created by Samuel Goodwin on 3/23/10.
//  Copyright 2010 ID345. All rights reserved.
//

#import "NSArrayAdditions.h"

@implementation NSArray (ID345Additions)
- (NSArray *)collectWithBlock:(CollectBlock)block{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
	for(NSUInteger i = 0;i<[self count];i++){
		[array addObject:block([self objectAtIndex:i])];
	}
	return array;
}

- (Contact*)selectWithBlock:(SelectBlock)block{
	Contact *value = nil;
	for(NSUInteger i = 0;i<[self count];i++){
		value = block((Contact*)[self objectAtIndex:i], value);
	}
	return value;
}

+ (NSArray *)arrayThatCounts:(NSUInteger)count{
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
	for(NSUInteger i=1;i<=count;i++){
		NSString *string = [[NSString alloc] initWithFormat:@"%d", i];
		[result addObject:string];
		//[string release];
	}
	return result;
}
@end
