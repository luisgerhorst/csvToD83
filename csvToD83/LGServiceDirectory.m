//
//  LGServiceDirectory
//  csvToD83
//
//  Created by Luis Gerhorst on 16.12.13.
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

/*

Todo:
remove parantheses from csv strings

*/

#import "LGServiceDirectory.h"
#import "CHCSVParser.h"
#import "LGOrdinalNumber.h"
#import "LGStack.h"
#import "LGSet.h"
#import "LGServiceGroup.h"
#import "LGService.h"
#import "LGMutableOrdinalNumber.h"

BOOL isEmpty(NSString *string) {
	NSString *trimmed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	return [trimmed length] == 0;
}

NSUInteger digitsCount(NSInteger i) {
	return i > 0 ? (NSUInteger)log10((double)i) + 1 : 1;
}

@implementation LGServiceDirectory

/*
 * Reads a csv with a specific structure and return a object structure
 */
+ (LGServiceDirectory *)serviceDirectoryWithContentsOfCSVFile:(NSString *)csvFilePath
{
	
	LGServiceDirectory *serviceDirectory = [[LGServiceDirectory alloc] init];
	
	NSArray *array = [NSArray arrayWithContentsOfCSVFile:csvFilePath];
	
	// NSLog(@"converted csv to array %@", array);
	
	LGStack *stack = [[LGStack alloc] init]; // stack that contains current parent of each node layer
	[stack push:serviceDirectory];
	
	// remove parantheses from strings with commas
	
	for (NSArray *line in array) {
		
		LGOrdinalNumber *ordinalNumber = [[LGOrdinalNumber alloc] initWithString:[line objectAtIndex:0]]; // nil if no valid string
		
		// ServiceGroup:
		if (ordinalNumber &&
			[ordinalNumber forGroup]) {
			
			LGServiceGroup *group = [[LGServiceGroup alloc] initWithTitle:[line objectAtIndex:1]];
			
			NSUInteger toPop = [stack heigth] - [ordinalNumber depth];
			[stack pop:toPop];
			[[stack objectOnTop] appendChild:group];
			[stack push:group];
			
		// Service:
		} else if (ordinalNumber &&
				   ![ordinalNumber forGroup]) {
			
			LGService *service = [[LGService alloc] initWithTitle:[line objectAtIndex:1] ofQuantity:[[line objectAtIndex:2] floatValue] inUnit:[line objectAtIndex:3] withCSVTypeString:[line objectAtIndex:4]];
			
			NSUInteger toPop = [stack heigth] - [ordinalNumber depth]; // maybe you have to pop another service first
			[stack pop:toPop];
			[[stack objectOnTop] appendChild:service];
			[stack push:service];
			
		// Service Text Chunk:
		} else if ([[stack objectOnTop] class] == [LGService class] &&
				   isEmpty([line objectAtIndex:0]) &&
				   !isEmpty([line objectAtIndex:1])) {
			
			[[stack objectOnTop] appendTextChunk:[line objectAtIndex:1]];
		
		}
		
	}
	
	if (![serviceDirectory layersValid]) @throw [NSException exceptionWithName:@"LGInvalidLayers" reason:@"Each service must have the same number of parent layers" userInfo:nil];
	
	return serviceDirectory;
	
}

- (id)init
{
	self = [super init];
	client = @"";
	project = @"";
	description = @"";
	date = [NSDate date];
	return self;
}

// Accessors

- (void)setProject:(NSString *)aProjectTitle
{
	project = aProjectTitle;
}

- (void)setDescription:(NSString *)aServiceDirectoryDescription
{
	description = aServiceDirectoryDescription;
}

- (void)setClient:(NSString *)aClientName
{
	client = aClientName;
}

- (void)setDate:(NSDate *)aDate
{
	date = aDate;
}

// D83

- (BOOL)writeToD83File:(NSString *)d83FilePath error:(NSError *__autoreleasing *)error
{
	
	NSString *string = [self d83Value];
	
	NSData *ASCIIData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *ASCIIString = [[NSString alloc] initWithData:ASCIIData encoding:NSASCIIStringEncoding];
	BOOL writeSuccess = [ASCIIString writeToFile:d83FilePath atomically:NO encoding:NSUTF8StringEncoding error:error];
	if (!writeSuccess) return NO;
	
	return YES;
	
}

- (NSString *)d83Value
{
	
	NSArray *sets = [self d83Sets];
	
	NSMutableString *d83String = nil;
	NSUInteger setNumber = 1;
	for (LGSet *set in sets) {
		if (!d83String) d83String = [NSMutableString stringWithFormat:@"%@", [set stringForSetNumber:setNumber]];
		else [d83String appendFormat:@"\n%@", [set stringForSetNumber:setNumber]];
		setNumber++;
	}
	
	return d83String;
	
}

- (NSArray *)d83Sets
{
	NSMutableArray *sets = [NSMutableArray array];
	
	[sets addObject:[self d83Set00]];
	[sets addObject:[self d83Set01]];
	[sets addObject:[self d83Set02]];
	[sets addObject:[self d83Set03]];
	
	LGMutableOrdinalNumber *ordinalNumber = [[LGMutableOrdinalNumber alloc] initWithScheme:[self d83Data74]];
	
	// children are top objects in ordinal number
	for (LGNode *child in children) {
		[ordinalNumber next];
		[sets addObjectsFromArray: [child d83SetsWithOrdinalNumber:ordinalNumber]]; // must leave ordinal number as received after execution
	}
	
	[sets addObject:[self d83Set99]];
	
	return sets;
}

// Sets

- (LGSet *)d83Set00 // 00 Eröffnungssatz Leistungsverzeichnis
{
	LGSet *set = [[LGSet alloc] init];
	[set setType:00];
	[set setString:@"83" range:NSMakeRange(10, 2)]; // DP
	[set setString:@"L" range:NSMakeRange(12, 1)]; // KURZLANG
	[set setString:[self d83Data74] range:NSMakeRange(62, 9)]; // OZMASKE
	[set setString:@"90" range:NSMakeRange(71, 2)]; // VERSDTA
	return set;
}

- (LGSet *)d83Set01 // 01 Information Leistungsverzeichnis
{
	LGSet *set = [[LGSet alloc] init];
	[set setType:01];
	
	// todo: cut description to avoid error
	
	[set setString:description range:NSMakeRange(2,40)]; // LVBEZ
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd.MM.YY"];
	NSString *dateString = [dateFormatter stringFromDate:date];
	[set setString:dateString range:NSMakeRange(42,8)]; // LVDATUM
	
	return set;
}

- (LGSet *)d83Set02 // 02 Information Projekt
{
	LGSet *set = [[LGSet alloc] init];
	[set setType:02];
	
	// todo: cut project to avoid error
	[set setString:project range:NSMakeRange(2,60)]; // PROBEZ
	
	return set;
}

- (LGSet *)d83Set03 // 03 Information Auftraggeber
{
	LGSet *set = [[LGSet alloc] init];
	[set setType:03];
	
	// todo: cut client to avoid error
	[set setString:client range:NSMakeRange(2,60)]; // AGBEZ
	
	return set;
}

- (LGSet *)d83Set99 // 99 Abschlußsatz Leistungsverzeichnis
{
	LGSet *set = [[LGSet alloc] init];
	[set setType:99];
	
	[set setInteger:[self d83Data9] range:NSMakeRange(69,5)]; // ANZTEIL
	
	return set;
}

// Data

- (NSString *)d83Data74 // 74 - OZMASKE - Maske zur OZ-Interpretation
{
	/* maxChildCounts rules
	 * - the layer befor the layer with 0 if the max number of Service
	 * - each layer before the layer with services is a group layer
	 * - array of NSNumbers
	 */
	NSArray *maxChildCounts = [super maxChildCounts]; // of NSNumbers
	NSMutableString *scheme = [NSMutableString string];
	NSUInteger groupDepth = 1;
	
	// Groups
	for (NSUInteger i = 0; i < [maxChildCounts count] - 2; i++) {
		NSUInteger digits = digitsCount([[maxChildCounts objectAtIndex:i] integerValue]);
		for (NSUInteger i = 0; i < digits; i++) [scheme appendFormat:@"%lu", (unsigned long)groupDepth];
		groupDepth++;
	}
	
	// Service
	NSUInteger serviceDigits = digitsCount([[maxChildCounts objectAtIndex:[maxChildCounts count] - 2] integerValue]);
	for (NSUInteger i = 0; i < serviceDigits; i++) [scheme appendString:@"P"];
	
	// Zeros
	while ([scheme length] < 9) [scheme appendString:@"0"];
	
	// Validate
	if ([scheme length] != 9) @throw [NSException exceptionWithName:@"LGServiceDirectory_d83Date74" reason:@"Resulting data element if too long" userInfo:nil];
	
	return scheme;
	
}

- (NSUInteger)d83Data9 // 9 - ANZTEIL - Anzahl der Teilleistungen im Leistungsverzeichnis
{
	return [super servicesCount];
}

// Other

- (NSString *)description
{
	return @"<ServiceDirectory>";
}

@end
