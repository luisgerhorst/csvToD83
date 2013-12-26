//
//  LGServiceGroup.m
//  csvToD83
//
//  Created by Luis Gerhorst on 16.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import "LGServiceGroup.h"
#import "LGMutableOrdinalNumber.h"
#import "LGSet.h"

@implementation LGServiceGroup

- (id)init
{
	@throw [NSException exceptionWithName:@"LGServiceGroupInitialization" reason:@"Use initWithTitle:, not init" userInfo:nil];
}

- (id)initWithTitle:(NSString *)string
{
	self = [super init];
	title = string;
	type = LGServiceGroup_TYPE_N;
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<Group: %@>", title];
}

// Overwriting LGNode:

// D83

- (NSArray *)d83SetsWithOrdinalNumber:(LGMutableOrdinalNumber *)ordinalNumber
{
	NSMutableArray *sets = [NSMutableArray array];
	[sets addObject:[self d83Set11WithOrdinalNumber:ordinalNumber]];
	[sets addObject:[self d83Set12]];
	
	// put your own children one layer under you
	[ordinalNumber layerDown];
	for (LGNode *child in children) {
		[ordinalNumber next]; // remeber, each new layer starts at 0
		[sets addObjectsFromArray: [child d83SetsWithOrdinalNumber:ordinalNumber]];
	}
	[ordinalNumber layerUp];
	
	[sets addObject:[self d83Set31WithOrdinalNumber:ordinalNumber]];

	return sets;
}

// Sets

- (LGSet *)d83Set11WithOrdinalNumber:(LGMutableOrdinalNumber *)ordinalNumber // 11 - Beginn einer LV-Gruppe
{
	LGSet *set = [[LGSet alloc] init];
	[set setType:11];
	[set setString:[ordinalNumber stringValue] range:NSMakeRange(2, 9)]; // OZ
	[set setString:[self d83Data67] range:NSMakeRange(11, 1)]; // LVGRART
	return set;
}

- (LGSet *)d83Set12 // 12 - Bezeichnung der LV-Gruppe
{
	LGSet *set = [[LGSet alloc] init];
	[set setType:12];
	[set setString:title range:NSMakeRange(2, 40)]; // LVGRBEZ
	return set;
}

- (LGSet *)d83Set31WithOrdinalNumber:(LGMutableOrdinalNumber *)ordinalNumber // 31 - Ende der LV-Gruppe
{
	LGSet *set = [[LGSet alloc] init];
	[set setType:31];
	[set setString:[ordinalNumber stringValue] range:NSMakeRange(2, 9)]; // OZ
	return set;
}

// Data

- (NSString *)d83Data67 // 67 - LVGRART - Art der LV-Gruppe (as string)
{
	switch (type) {
		case LGServiceGroup_TYPE_N:
			return @"N";
		case LGServiceGroup_TYPE_G:
			return @"G";
		case LGServiceGroup_TYPE_A:
			return @"A";
	}
}

@end
