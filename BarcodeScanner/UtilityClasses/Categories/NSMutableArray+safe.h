//
//  NSMutableArray+safe.h
//  DripThat
//
//  Updated by Temp on 12/07/14.
//  Copyright (c) 2014 Rupesh Borkar. All rights reserved.
//
//  Created by Tomohisa Takaoka on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSMutableArray (safe)

/*
 *  Returns 'nil' if index is greater than bounds of array.
 */
-(id) safeObjectAtIndex:(NSUInteger)index;

/*
 * Does not attempt to replace, if index is greater than count of array.
 */
- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

@end
