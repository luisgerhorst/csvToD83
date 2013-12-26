//
//  LGStack.h
//  csvToD83
//
//  Created by Luis Gerhorst on 18.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGStack : NSObject {
	NSMutableArray *stack;
}

- (id)init;
- (void)push:(id)object;
- (void)pop;
- (void)pop:(NSUInteger)toPop;
- (NSUInteger)heigth;
- (id)objectOnTop;

@end
