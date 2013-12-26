//
//  LGSet.h
//  csvToD83
//
//  Created by Luis Gerhorst on 21.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGSet : NSObject {  // Zeile / Satz
	NSMutableString *string; // <= 74 chars
}

- (void)setType:(NSUInteger)aInt;
- (void)setString:(NSString *)string range:(NSRange)range;
- (void)setInteger:(NSUInteger)number range:(NSRange)range;
- (void)setFloat:(float)number range:(NSRange)range comma:(NSUInteger)comma;

- (NSString *)stringForSetNumber:(NSUInteger)aSetNumber;

@end
