//
//  LGOrdinalNumber.h
//  csvToD83
//
//  Created by Luis Gerhorst on 17.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGOrdinalNumber : NSObject {
	NSArray *ordinalNumber;
	BOOL forGroup;
}

- (id)initWithString:(NSString *)string;
- (BOOL)forGroup;
- (NSUInteger)depth;

@end
