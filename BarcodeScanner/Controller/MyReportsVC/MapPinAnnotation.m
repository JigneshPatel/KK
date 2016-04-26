//
//  MapPinAnnotation.m
//  BrandReporter
//
//  Created by Gauri Shankar on 09/08/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "MapPinAnnotation.h"

@implementation MapPinAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description;
{
    self = [super init];
    if (self)
    {
        coordinate = location;
        title = placeName;
        subtitle = description;
    }
    
    return self;
}

@end
