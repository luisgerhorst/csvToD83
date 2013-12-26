//
//  LGOrdinalNumber.m
//  csvToD83
//
//  Created by Luis Gerhorst on 17.12.13.
/*
 The MIT License (MIT)
 
 Copyright (c) 2013 Luis Gerhorst
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
