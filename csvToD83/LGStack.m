//
//  LGStack.m
//  csvToD83
//
//  Created by Luis Gerhorst on 18.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import "LGStack.h"

@implementation LGStack

- (id)init
{
	self = [super init];
	stack = [NSMutableArray array];
	return self;
}

- (void)push:(id)object
{
	// NSLog(@"pushing object of class %@", object);
	[stack addObject:object];
}

- (void)pop
{
	[stack removeLastObject];
}

- (void)pop:(NSUInteger)toPop
{
	for (int i = 0; i < toPop; i++) [stack removeLastObject];
}

- (NSUInteger)heigth
{
	return [stack count];
}

- (id)objectOnTop
{
	NSUInteger count = [stack count];
	if (count > 0) return [stack objectAtIndex:count - 1];
	else return nil;
}

@end
