//
//  LGService.h
//  csvToD83
//
//  Created by Luis Gerhorst on 16.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGServiceType.h"
#import "LGNode.h"

@interface LGService : LGNode {
	
	// Beginn einer Teilleistung
	float quantity; // MENGE
	NSString *unit; // EINHEIT
	LGServiceType *type; // contains POSART1, POSART2 and POSTYP
	
	// Kurztext
	NSString *title; // KURZTEXT
	
	// Langtext
	NSMutableString *text; // LANGTEXT
	
}

- (id)initWithTitle:(NSString *)aTitle ofQuantity:(float)aQuantity inUnit:(NSString *)aUnit withCSVTypeString:(NSString *)typeString;
- (void)appendTextChunk:(NSString *)textChunk;

@end
