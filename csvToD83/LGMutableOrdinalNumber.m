//
//  LGMutableOrdinalNumber.m
//  csvToD83
//
//  Created by Luis Gerhorst on 24.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import "LGMutableOrdinalNumber.h"

@implementation LGMutableOrdinalNumber

- (id)init
{
	@throw [NSException exceptionWithName:@"LGMutableOrdinalNumberInitialization" reason:@"Use initWithD83SchemeString:, not init" userInfo:nil];
}

- (id)initWithScheme:(NSString *)string // string: OZMASKE
{
	self = [super init];
	
	NSMutableArray *aScheme = [NSMutableArray array];
	NSUInteger schemeIndex = -1; // what element we're editing, will be incremented to 0 when reaching first char
	NSString *previousCharacter = nil;
	for (int i = 0; i < [string length]; i++) {
		NSString *character  = [NSString stringWithFormat:@"%c", [string characterAtIndex:i]];
		if ([character isEqual:previousCharacter]) { // same
			[aScheme replaceObjectAtIndex:schemeIndex withObject:[NSNumber numberWithUnsignedInteger:[[aScheme objectAtIndex:schemeIndex] integerValue] + 1]]; // one more digit for this layer
		} else if ([character isEqual: @"0"]) break; // end all at 0
		else { // new char
			schemeIndex++; // layer down
			[aScheme addObject:[NSNumber numberWithUnsignedInteger:1]]; // has 1 digit
			previousCharacter = character; // previousCharacter has changed
		}
	}
	
	scheme = aScheme;
	location = [NSMutableArray arrayWithObject:[NSNumber numberWithUnsignedInteger:0]]; // increment before use of string
	
	return self;
}

// todo: finish

- (void)layerUp
{
	[location removeLastObject];
}

// starts at 0, must be incremented before generating first string
- (void)layerDown
{
	[location addObject:[NSNumber numberWithUnsignedInteger:0]];
}

- (void)next
{
	NSUInteger lastIndex = [location count]-1;
	NSNumber *lastIncremented = [NSNumber numberWithUnsignedInteger:[[location objectAtIndex:lastIndex] unsignedIntegerValue] + 1];
	[location replaceObjectAtIndex:lastIndex withObject:lastIncremented];
}

// todo: test this method, should work
- (NSString *)stringValue // get OZ
{
	
	NSMutableString *ordinalNumberString = [NSMutableString string];
	
	NSUInteger locationCount = [location count];
	NSUInteger locationIndex = 0;
	for (NSNumber *digitsObject in scheme) { // each layer in scheme
		NSUInteger digits = [digitsObject unsignedIntegerValue];
		NSString *string;
		if (locationIndex < locationCount) { // if location is afterwards, insert number
			string = [NSString stringWithFormat:@"%lu", (unsigned long)[[location objectAtIndex:locationIndex] unsignedIntegerValue]]; // number to string
			while ([string length] < digits) string = [NSString stringWithFormat:@"0%@", string]; // fill up with 0 (befor number)
		} else { // if location is before, insert spaces
			string = @"";
			while ([string length] < digits) string = [NSString stringWithFormat:@"%@ ", string]; // fill up with spaces
		}
		[ordinalNumberString appendString:string]; // add chunk to final string
		locationIndex++;
	}
	
	return ordinalNumberString;
	
}

@end
