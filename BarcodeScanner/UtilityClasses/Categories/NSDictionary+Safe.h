//
//  NSDictionary+Safe.h
//  winkApp
//
//  Created by Temp on 13/12/14.
//  Copyright (c) 2014 kuriosthele. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)

/**
 * Returns the object for the given key, if it is in the dictionary, else nil.
 * This is useful when using SBJSON, as that will return [NSNull null] if the value was 'null' in the parsed JSON.
 * @param The key to use
 * @return The object or, if the object was not set in the dictionary or was NSNull, nil
 */
- (id)safeObjectForKey:(id)aKey;

@end
