//
//  LGNode.h
//  csvToD83
//
//  Created by Luis Gerhorst on 18.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGMutableOrdinalNumber;

@interface LGNode : NSObject {
	/*
	 * Child rules:
	 * - must be from the same class
	 * - must have the same number of sub-layers
	 */
	NSMutableArray *children;
}

// local:

- (id)init;
- (id)initWithoutChildren;
- (NSMutableArray *)children;
- (void)appendChild:(id)newChild;
- (BOOL)layersValid;

// recursive:

- (NSArray *)maxChildCounts;
- (NSUInteger)servicesCount; // with end element

// inheritating children must overwrite:

- (NSArray *)d83SetsWithOrdinalNumber:(LGMutableOrdinalNumber *)ordinalNumber;

@end
