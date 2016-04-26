//
//  LocationHelper.h
//  winkApp
//
//  Created by Temp on 27/12/14.
//  Copyright (c) 2014 kuriosthele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GooglePlace.h"

// #########################
@class LocationHelper;

@protocol LocationHelperPlaceProtocol <NSObject>

@required

- (void)locationHelper:(LocationHelper *)helper
         didFindPlaces:(NSArray *)places
               nearLat:(NSString *)latitude
               andLong:(NSString *)longitude;

- (void)locationHelper:(LocationHelper *)helper
        didPlaceDetail:(GooglePlaceDetail *)placeDetail
            forPlaceId:(NSString *)placeId;

- (void)locationHelper:(LocationHelper *)helper
     didFindMorePlaces:(NSArray *)places
               nearLat:(NSString *)latitude
               andLong:(NSString *)longitude;

- (void)locationHelper:(LocationHelper *)helper
placesAPIReceivedError:(NSError *)error
                forLat:(NSString *)lat
               andLong:(NSString *)lng;

@end

// ##########################

@interface LocationHelper : NSObject

@property (nonatomic, readonly) NSString *currentLat;
@property (nonatomic, readonly) NSString *currentLong;
@property (nonatomic, readonly) GooglePlace *currentPlace;
@property (nonatomic, strong, readonly) NSDate *reqTime;

@property (nonatomic, strong) id<LocationHelperPlaceProtocol>placesDelegate;

+ (id)sharedManager;

- (instancetype)init __attribute__((unavailable("use sharedManager")));

- (void)getPlaceNearlat:(NSString *)lat andLong:(NSString *)longitude;


- (void)getDetailsOfPlaceId:(NSString *)placeId;

- (void)clearCachedData;

@end
