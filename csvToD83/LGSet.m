//
//  LGSet.m
//  csvToD83
//
//  Created by Luis Gerhorst on 21.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import "LGSet.h"

@implementation LGSet

- (id)init
{
	self = [super init];
	string = [NSMutableString string];
	for (int i = 0; i < 74; i++) [string appendString:@" "];
	return self;
}

// shortcuts:

- (void)setType:(NSUInteger)aInt
{
	[self setInteger:aInt range:NSMakeRange(0, 2)];
}

// setter:

/*
 * aString: String with length <= range.length to be inserted into the set (line)
 */
- (void)setString:(NSString *)s range:(NSRange)range // nicht-numerisch, werden mit lehrzeichen aufgefüllt
{
	if ([s length] > range.length) @throw [NSException exceptionWithName:@"LGSet_SetStringForRange" reason:@"String is longer than range" userInfo:nil];
	while ([s length] < range.length) s = [NSString stringWithFormat:@"%@ ", s];
	[string replaceCharactersInRange:range withString:s];
}

- (void)setInteger:(NSUInteger)number range:(NSRange)range // Numerisch, werden mit Nullen vor zahl aufgefüllt
{
	NSString *s = [NSString stringWithFormat:@"%lu", (unsigned long)number];
	while ([s length] < range.length) s = [NSString stringWithFormat:@"0%@", s];
	[self setString:s range:range];
}

- (void)setFloat:(float)floatNumber range:(NSRange)range comma:(NSUInteger)comma
{
	// split
	NSUInteger integerNumber = floor(floatNumber);
	float decimalNumber = floatNumber - integerNumber;
	
	// decimal portion
	NSMutableString *decimalStringFormat = [[NSMutableString alloc] initWithString:@"%."];
	[decimalStringFormat appendFormat:@"%lu", (long unsigned)comma];
	[decimalStringFormat appendString:@"f"];
	NSString *decimalFullString = [[NSString alloc] initWithFormat:decimalStringFormat, decimalNumber];
	NSString *decimalString = [decimalFullString substringFromIndex:2]; // has right length
	
	[self setInteger:integerNumber range:NSMakeRange(range.location, range.length - comma)];
	[self setString:decimalString range:NSMakeRange(range.location + (range.length - comma), comma)];
}

// getter:

/*
 * returns full line with set number 'number'
 */
- (NSString *)stringForSetNumber:(NSUInteger)number
{
	
	if (number > 999999)  @throw [NSException exceptionWithName:@"LGSet_StringForSetNumber" reason:@"Set number can not have more then 6 digits" userInfo:nil];
	
	// generate string starting with zeros and number at end
	NSString *setNumberString = [NSString stringWithFormat:@"%lu", (unsigned long)number];
	while ([setNumberString length] < 6) setNumberString = [NSString stringWithFormat:@"0%@", setNumberString];
	
	// return string + setNumber
	return [NSString stringWithFormat:@"%@%@", string, setNumberString];
	
}

- (NSString *)description
{
	return [self stringForSetNumber:0];
}

@end
