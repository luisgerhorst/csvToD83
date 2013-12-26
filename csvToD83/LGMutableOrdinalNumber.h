//
//  LGMutableOrdinalNumber.h
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

#import <Foundation/Foundation.h>

@interface LGMutableOrdinalNumber : NSObject {
	NSMutableArray *location; // the ordinal number as array, representing the current position in the tree
	NSArray *scheme; // defining number of digits per layer and max number of layers
}

// create:

- (id)initWithScheme:(NSString *)string; // string: OZMASKE

// modify:

- (void)layerUp; // move one layer up in the tree
- (void)layerDown; // move down in tree
- (void)next; // next object in current layer in tree

// export:

- (NSString *)stringValue; // returns: OZ

@end
