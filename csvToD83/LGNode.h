//
//  LGNode.h
//  csvToD83
//
//  Created by Luis Gerhorst on 18.12.13.
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

#import <Foundation/Foundation.h>

@class LGOrdinalNumber;
@class LGOrdinalNumberScheme;

@interface LGNode : NSObject {
    /*
     Child rules:
     - same class
     - same number of sub-layers
     */
    NSMutableArray *children;
}

// Local:

- (id)init;
- (id)initWithoutChildren;
- (NSMutableArray *)children;
- (void)appendChild:(id)newChild;
- (BOOL)layersValid;

// Recursive:

- (NSArray *)maxChildCounts;
- (NSUInteger)servicesCount; // with end element

// Also in protocol:
- (NSArray *)d83SetsWithOrdinalNumber:(LGOrdinalNumber *)ordinalNumber ofScheme:(LGOrdinalNumberScheme *)ordinalNumberScheme;

@end

// Inherting classes should conform to this protocol:
@protocol LGNodeInherting
- (NSArray *)d83SetsWithOrdinalNumber:(LGOrdinalNumber *)ordinalNumber ofScheme:(LGOrdinalNumberScheme *)ordinalNumberScheme;
@end
