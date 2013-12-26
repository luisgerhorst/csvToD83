//
//  LGMutableOrdinalNumber.h
//  csvToD83
//
//  Created by Luis Gerhorst on 24.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

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
