//
//  LGMutableOrdinalNumber.m
//  csvToD83
//
//  Created by Luis Gerhorst on 24.12.13.
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
