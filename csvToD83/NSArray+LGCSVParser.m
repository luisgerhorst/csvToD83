//
//  NSArray+LGCSVParser.m
//  csvToD83
//
//  Created by Luis Gerhorst on 28/01/14.
//  Copyright (c) 2014 Luis Gerhorst. All rights reserved.
//

#import "NSArray+LGCSVParser.h"

static unichar const comma = ',';
static unichar const semicolon = ';';
static unichar const colon = ':';
static unichar const tab = '\t';
static unichar const space = ' ';

NSRegularExpression *fieldRegExForDelimiter(unichar delimiter) {
    NSString *fieldRegExPattern = [NSString stringWithFormat:@"(?<=^|%C)(\"(?:[^\"]|\"\")*\"|[^%C]*)", delimiter, delimiter]; // Via http://stackoverflow.com/questions/3268622/regex-to-split-line-csv-file - works very good. Handles double double quotes, fields containing a delimiter and starting and ending with double quotes, delimiter after double double quotes in field that starts and ends with double quotes.
    return [NSRegularExpression regularExpressionWithPattern:fieldRegExPattern options:0 error:nil];
}

unichar detectDelimiter(NSString const *csvString) {
    NSArray const *lines = [csvString componentsSeparatedByString:@"\n"];
    
    NSInteger delimitersFieldCounts[] = {-1, -1, -1, -1, -1}; // Is -1 if field count wasn't the same in each line, if count was the same -> contains field count. Same order as in unichar delimiters array.
    unichar delimiters[] = {comma, semicolon, colon, tab, space}; // Sorted by importance. You can modify this but make sure you also change delimitersFieldCounts (same length as delimiters, filled with -1) and delimitersCount (length of delimiters and delimitersFieldCounts).
    NSUInteger delimitersCount = 5;
    
    for (NSUInteger i = 0; i < delimitersCount; i++) {
        unichar delimiter = delimiters[i];
        NSRegularExpression *fieldRegEx = fieldRegExForDelimiter(delimiter);
        
        NSUInteger fieldCount;
        BOOL fieldCountSet = NO;
        BOOL allLinesHaveSameFieldCount = YES;
        for (NSString *line in lines) { // For each line ...
            NSMutableArray *lineArray = [NSMutableArray array]; // Will be filled with the fields.
            NSArray *fieldMatches = [fieldRegEx matchesInString:line options:0 range:NSMakeRange(0,[line length])]; // Matches every field.
            for (NSTextCheckingResult *fieldMatch in fieldMatches) { // Each field match ...
                NSString *field = [NSMutableString stringWithString:[line substringWithRange:[fieldMatch range]]]; // Get field string.
                [lineArray addObject:field]; // Add field string to line array.
            }
            
            if (!fieldCountSet) { // Set fieldCount in first line.
                fieldCount = [lineArray count];
                fieldCountSet = YES;
            } else if (fieldCount != [lineArray count]) { // End with negative result for this delimiter if fieldCount of this line isn't the same as in the previous ones.
                allLinesHaveSameFieldCount = NO;
                break;
            }
        }
        
        if (allLinesHaveSameFieldCount) delimitersFieldCounts[i] = fieldCount;
    }
    
    unichar delimiterWithMaxFieldCount = delimiters[0]; // Delimiters should be sorted by importance and how common/popular they are, this makes the first one the default.
    NSInteger maxFieldCount = 0; // Will be replaced if delimiter results in one field in each line.
    for (NSInteger i = delimitersCount-1; i >= 0; i--) { // Go from behind because more common/popular delimiters are at the beginning.
        if (delimitersFieldCounts[i] > maxFieldCount) { // The delimiter with the higthest count always replaces other.
            maxFieldCount = delimitersFieldCounts[i];
            delimiterWithMaxFieldCount = delimiters[i];
        } else if (delimitersFieldCounts[i] == maxFieldCount) // Replace delimiters at the end of array with newer delimiters with same field count.
            delimiterWithMaxFieldCount = delimiters[i];
    }
    
    return delimiterWithMaxFieldCount;
}

@implementation NSArray (LGCSVParser)

+ (instancetype)arrayWithCSVString:(NSString *)csvString
{
    return [NSArray arrayWithCSVString:csvString delimiter:detectDelimiter(csvString)];
}

+ (instancetype)arrayWithCSVString:(NSString *)csvString delimiter:(unichar)delimiter
{
    
    // Matches fields.
    NSRegularExpression *fieldRegEx = fieldRegExForDelimiter(delimiter);
    
    // Quotes at start and end of string.
    NSRegularExpression * const quotesAtStartAndEndRegEx = [NSRegularExpression regularExpressionWithPattern:@"^\".+\"$" options:0 error:nil]; // Matches every string that starts and ends with double quotes and has something else in between.
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *lines = [csvString componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) { // For each line ...
        NSMutableArray *lineArray = [NSMutableArray array]; // Will be filled with the fields.
        NSArray *fieldMatches = [fieldRegEx matchesInString:line options:0 range:NSMakeRange(0,[line length])]; // Matches every field.
        for (NSTextCheckingResult *fieldMatch in fieldMatches) { // Each field match ...
            NSMutableString *field = [NSMutableString stringWithString:[line substringWithRange:[fieldMatch range]]]; // Get field string.
            if ([quotesAtStartAndEndRegEx numberOfMatchesInString:field options:0 range: NSMakeRange(0, [field length])]) { // If field starts and ends with double quotes ...
                [field deleteCharactersInRange:NSMakeRange(0, 1)]; // Remove first ...
                [field deleteCharactersInRange:NSMakeRange([field length]-1, 1)]; //  ... and last char.
            }
            [field replaceOccurrencesOfString:@"\"\"" withString:@"\"" options:0 range:NSMakeRange(0, [field length])]; // Replace all double double quotes by single quotes.
            [lineArray addObject:field]; // Add final field string to line array.
        }
        [array addObject:lineArray]; // Add line array to array.
    }
    
    return array; // Return the array of arrays containing strings.
}

@end
