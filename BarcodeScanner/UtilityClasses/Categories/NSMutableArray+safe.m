//
//  NSMutableArray+safe.m
//  DripThat
//
//  Updated by Temp on 12/07/14.
//  Copyright (c) 2014 Rupesh Borkar. All rights reserved.
//
//  Created by Tomohisa Takaoka on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

#import "NSMutableArray+safe.h"

@implementation NSMutableArray (safe)

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index>=self.count) {
        return;  // do nothing.
    }
    return [self replaceObjectAtIndex:index withObject:anObject];
}

-(id) safeObjectAtIndex:(NSUInteger)index {
    if (index>=self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end
