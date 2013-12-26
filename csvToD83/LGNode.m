//
//  LGNode.m
//  csvToD83
//
//  Created by Luis Gerhorst on 18.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import "LGNode.h"
#import "LGService.h"
#import "LGMutableOrdinalNumber.h"

@implementation LGNode

- (id)init
{
	self = [super init];
	children = [NSMutableArray array];
	return self;
}

- (id)initWithoutChildren
{
	self = [super init];
	return self;
}

- (NSMutableArray *)children
{
	return children;
}

/*
 existing layers must be complete (all their children must be already added)
 */
- (void)appendChild:(LGNode *)aChild
{
	// todo: check if same number of sublayers
	if ([children count] && ([[children objectAtIndex:0] class] != [aChild class])) @throw [NSException exceptionWithName:@"LGBadAddChildCall" reason:@"Node can only contain objects of same class" userInfo:nil]; // if node already has children, new child must be of the same type
	else [children addObject:aChild];
}

- (BOOL)layersValid
{
	NSUInteger layers = [[children objectAtIndex:0] layers];
	for (LGNode *child in children) {
		if ([child layers] != layers) return NO;
	}
	return YES;
}

// recursive stuff:

- (NSUInteger)layers
{
	if (children && [children count])
		return [[children objectAtIndex:0] layers] + 1;
	else
		return 1;
}

/*
 Array with max number of children of each layer
 If has no children returns array with a zero
 needed for efficient OZMASKE
 */
- (NSArray *)maxChildCounts
{
	
	NSMutableArray *childrensMaxCounts;
	for (LGNode *child in children) { // each child
		NSArray *childsMaxCounts = [child maxChildCounts]; // get max child counts
		if (!childrensMaxCounts) childrensMaxCounts = [NSMutableArray arrayWithArray:childsMaxCounts];
		else {
			for (NSUInteger i = 0; i < [childsMaxCounts count]; i++) { // for each layer (under self)
				if ([[childrensMaxCounts objectAtIndex:i] compare:[childsMaxCounts objectAtIndex:i]] == NSOrderedAscending) { // if childs max of layer > max of layer
					[childrensMaxCounts replaceObjectAtIndex:i withObject:[childsMaxCounts objectAtIndex:i]]; // max of layer = childs max of that layer
				}
			}
		}
	}
	
	// append childrensMaxCounts to own child count array
	NSMutableArray *full = [NSMutableArray arrayWithObject:[NSNumber numberWithInteger:[children count]]];
	[full addObjectsFromArray:childrensMaxCounts];
	
	return full;
}

// recursive with end element LGService
- (NSUInteger)servicesCount
{
	NSUInteger servicesCount = 0;
	for (LGNode *child in children) servicesCount += [child servicesCount];
	return servicesCount;
}

// to be overwritten:

/*
 rules:
 - always make the ordinal number ready for your children, they will directly insert themselves
 - return the ordinal number the same way you got it
 */
- (NSArray *)d83SetsWithOrdinalNumber:(LGMutableOrdinalNumber *)ordinalNumber
{
	@throw [NSException exceptionWithName:@"LGNode_d83SetsForOrdinalNumber" reason:@"Every class inheriting from LGNode has to overwrite the method - (NSArray *)d83SetsForOrdinalNumber:(LGMutableOrdinalNumber *)ordinalNumber" userInfo:nil];
}

@end
