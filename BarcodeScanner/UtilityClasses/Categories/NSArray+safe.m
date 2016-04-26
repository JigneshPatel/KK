//
//  NSArray+safe.m
//  DripThat
//
//  Updated by Temp on 12/07/14.
//  Copyright (c) 2014 Rupesh Borkar. All rights reserved.
//

//  C_POS
//
//  Created by Tomohisa Takaoka on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSArray+safe.h"

@implementation NSArray (NSArray_safe)

-(id) safeObjectAtIndex:(NSUInteger)index {
    if (index>=self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end
