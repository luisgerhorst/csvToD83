//
//  LGServiceGroup.h
//  csvToD83
//
//  Created by Luis Gerhorst on 16.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import "LGNode.h"

typedef NS_ENUM(NSInteger, LGServiceGroup_TYPE) { // LVGRART
    LGServiceGroup_TYPE_N, // N - Normalgruppe
    LGServiceGroup_TYPE_G, // G
    LGServiceGroup_TYPE_A, // A
};

@interface LGServiceGroup : LGNode { // LV-Gruppe
	
	// 11 Beginn einer LV-Gruppe
	LGServiceGroup_TYPE type; // LVGRART
	
	// 12 Bezeichnung einer LV-Gruppe
	NSString *title; // LVGRBEZ
	
}

- (id)initWithTitle:(NSString *)string;

@end
