//
//  NSDictionary+Safe.m
//  winkApp
//
//  Created by Temp on 13/12/14.
//  Copyright (c) 2014 kuriosthele. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)

- (id)safeObjectForKey:(id)aKey {
    id object = [self objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
