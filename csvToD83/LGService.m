//
//  LGService.m
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

#import "LGService.h"
#import "LGMutableOrdinalNumber.h"
#import "LGSet.h"

@implementation LGService

- (id)init
{
    @throw [NSException exceptionWithName:@"LGServiceInitialization" reason:@"Use initWithTitle:ofQuantity:inUnit:withCSVTypeString:, not init" userInfo:nil];
}

- (id)initWithTitle:(NSString *)aTitle ofQuantity:(float)aQuantity inUnit:(NSString *)aUnit withCSVTypeString:(NSString *)typeString
{
    self = [super initWithoutChildren];
    title = aTitle;
    quantity = aQuantity;
    unit = aUnit;
    type = [[LGServiceType alloc] initWithCSVString:typeString forServiceWithUnit:aUnit];
    text = [NSMutableString string];
    return self;
}

- (void)appendTextChunk:(NSString *)textChunk
{
    if ([text length]) [text appendString:@"\n"];
    [text appendString:textChunk];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Service: %@>", title];
}

// Overwriting LGNode:

- (NSUInteger)servicesCount // end recursion
{
    return 1;
}

// D83

- (NSArray *)d83SetsWithOrdinalNumber:(LGMutableOrdinalNumber *)ordinalNumber
{
    NSMutableArray *sets = [NSMutableArray array];
    [sets addObject:[self d83Set21WithOrdinalNumber:ordinalNumber]];
    [sets addObject:[self d83Set25]];
    
    // split text by lines and length
    NSArray *textLines = [text componentsSeparatedByString:@"\n"];
    NSMutableArray *cutTextLines = [NSMutableArray array];
    NSRegularExpression *lineRegExp = [NSRegularExpression regularExpressionWithPattern:@".{1,55}" options: 0 error:nil]; // max 55 chars
    for (NSString *line in textLines) {
        // split into line into chunks of max 55 chars
        NSArray *matches = [lineRegExp matchesInString:line options:0 range:NSMakeRange(0, [line length])];
        for (NSTextCheckingResult *match in matches) [cutTextLines addObject:[line substringWithRange:match.range]];
    }
    
    // add to sets
    for (NSString *chunk in cutTextLines) [sets addObject:[self d83Set26WithChunk:chunk]];
    
    return sets;
}

// Sets

- (LGSet *)d83Set21WithOrdinalNumber:(LGMutableOrdinalNumber *)ordinalNumber
{
    LGSet *set = [[LGSet alloc] init];
    [set setType:21];
    [set setString:[ordinalNumber stringValue] range:NSMakeRange(2, 9)]; // OZ
    [set setString:[type d83Data787980] range:NSMakeRange(11, 3)]; // POSART1 + POSART2 + POSTYP
    [set setFloat:quantity range:NSMakeRange(23,11) comma:3]; // MENGE
    [set setString:unit range:NSMakeRange(34,4)]; // EINHEIT
    return set;
}

- (LGSet *)d83Set25
{
    LGSet *set = [[LGSet alloc] init];
    [set setType:25];
    [set setString:title range:NSMakeRange(2, 70)]; // KURZTEXT
    return set;
}

- (LGSet *)d83Set26WithChunk:(NSString *)chunk
{
    LGSet *set = [[LGSet alloc] init];
    [set setType:26];
    [set setString:chunk range:NSMakeRange(5, 55)]; // LANGTEXT
    return set;
}

@end
