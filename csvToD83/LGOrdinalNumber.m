//
//  LGOrdinalNumber.m
//  csvToD83
//
//  Created by Luis Gerhorst on 17.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import "LGOrdinalNumber.h"

@implementation LGOrdinalNumber

- (id)init
{
	@throw [NSException exceptionWithName:@"LGOrdinalNumberInitialization" reason:@"Use initWithString:, not init" userInfo:nil];
}

- (id)initWithString:(NSString *)string
{
	self = [super init];
	
	// convert
	NSArray *strings = [string componentsSeparatedByString:@"."];
	NSMutableArray *numbers = [NSMutableArray array];
	for (NSString *s in strings) {
		[numbers addObject:[NSNumber numberWithInteger:(NSUInteger)[s integerValue]]]; // get unsigned int from string and put into array
	}
	
	// remove group 0
	forGroup = NO;
	if ([[numbers objectAtIndex:[numbers count]-1] integerValue] == 0) {
		[numbers removeLastObject];
		forGroup = YES;
	}
	
	ordinalNumber = numbers;
	
	// validate
	if ([ordinalNumber count] == 0) return nil;
	for (NSUInteger i = 0; i < [ordinalNumber count]; i++) {
		if ([[ordinalNumber objectAtIndex:i] integerValue] > 0) continue; // alle müssen größer 0 sein (group 0 schon entfernt)
		return nil;
	}
	
	return self;
}

- (BOOL)forGroup
{
	return forGroup;
}

- (NSUInteger)depth
{
	return [ordinalNumber count];
}

@end
