//
//  LocationHelper.m
//  winkApp
//
//  Created by Temp on 27/12/14.
//  Copyright (c) 2014 kuriosthele. All rights reserved.
//

#import "LocationHelper.h"
#import "NSDictionary+Safe.h"
#import "NSArray+safe.h"
#import "AFNetworking.h"

/**
 *  Google Places API app key:  iOS Key
 */
#define kGooglePlacesAPIiOSKey      @"AIzaSyAe93Ougvnt4rbCkHE_MrEEJGmUO93wD6o"

/**
 *  Google Places API app key:  browser Key (test purpose)
 */
#define kGooglePlacesAPIBrowserKey @"AIzaSyCbCPKyD0u0isJxPzNG_4rTq_1jOYuD_aA"

/**
 *  Google Places API app key:  browser Key 2 (test purpose)
 */
#define kGooglePlacesAPIBrowserKey2 @"AIzaSyD-Wqu3mbLcb2sRM_coKvjHzv-KRwFOpHo"
//@"AIzaSyAdIoz7SMgZ1ovpHyvGMOXfbTUz96h5fuI"
//@"AIzaSyDODrW9xpLbPggLyftX3Eqyimz3xOslai8"

#define kRadius1stLevel  @"25"  // meters
#define kRadius2stLevel  @"100"  // meters
#define kRadius3ndLevel  @"200"

@interface LocationHelper (){
    
    NSArray *_searchRadiusArray;
    
    /** This i sjust for testing purposes, On produciton this must not be used.*/
    BOOL _switchGoogleAPIKey;
}

@property (nonatomic, readwrite) NSInteger currentSearchRadiusIndex;

@property (nonatomic, strong) NSString *searchRadius;
@property (nonatomic, strong) NSMutableArray *currentPlaces;
@property (nonatomic, strong) GooglePlaceDetail *currentPlaceDetail;
@property (nonatomic, strong) NSString *currentplaceId;

@property (nonatomic, strong) NSMutableArray *currentAdditionalPlaces;
@property (nonatomic, readwrite) BOOL isMoreAccuratePlacesAPI;

@property (nonatomic, readwrite) NSString *currentLat;
@property (nonatomic, readwrite) NSString *currentLong;
@property (nonatomic, readwrite, strong) GooglePlace *currentPlace;
@property (nonatomic, strong) NSDate *reqTime;

@end



@implementation LocationHelper

+ (instancetype)sharedManager
{
    static LocationHelper *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        // --- call to super avoids a deadlock with the above allocWithZone
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init{
    
    if (self = [super init]) {

        _searchRadiusArray = [NSArray arrayWithObjects:@"25", @"75", @"150", @"250", nil];
    }
    return self;
}

#pragma mark

- (void)clearCachedData{
    NSLog(@"");
    if (self.currentPlaces) {
        [self.currentPlaces removeAllObjects];
    }
    self.currentSearchRadiusIndex = 0;
    self.currentPlaceDetail = nil;
    self.currentLat = @"";
    self.currentLong = @"";
    _switchGoogleAPIKey = NO;
}

#pragma mark -

- (void)getPlaceNearlat:(NSString *)lat andLong:(NSString *)longitude{
    
    self.reqTime = [NSDate date];
    self.isMoreAccuratePlacesAPI = NO;
    
    NSString *latLong = [NSString stringWithFormat:@"%@,%@", lat, longitude];
#if TARGET_IPHONE_SIMULATOR
    //if([lat doubleValue]==0 && [longitude doubleValue]==0){
    //latLong = [NSString stringWithFormat:@"%@,%@", @"28.51915",@"77.200835"];
    latLong = [NSString stringWithFormat:@"%@,%@", @"40.722388",@"-73.997641"];
    
    latLong = [NSString stringWithFormat:@"%@,%@", @"40.667813", @"-74.303076"];
    
    latLong = [NSString stringWithFormat:@"%@,%@", @"40.237510",@"-74.343195"];

    //}
#endif
    
    self.searchRadius = [_searchRadiusArray safeObjectAtIndex:self.currentSearchRadiusIndex]; // meters
    self.currentLat = lat;
    self.currentLong = longitude;
    
    NSString *types = @"";
    
    NSLog(@"Searching places with radius: '%@' ...",self.searchRadius);
    
    /*
    NSDictionary *params = @{@"location": latLong,
                             @"radius" : self.searchRadius,
                             @"types": types,
                             @"key": kGooglePlacesAPIBrowserKey};*/
    
    //NSString *formURLParams = [NSString stringWithFormat:@"location=%@&radius=%@&types=food&sensor=true&key=AIzaSyAe93Ougvnt4rbCkHE_MrEEJGmUO93wD6o",
      //                         latLong, searchRadius, types, kGOOGLE_API_KEY];
    
    /// *NSString *encodedParam = AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(xml, NSUTF8StringEncoding); /
    
    NSString *googleAPIKey = kGooglePlacesAPIBrowserKey2;
    if (_switchGoogleAPIKey) {
        googleAPIKey = kGooglePlacesAPIBrowserKey;
        NSLog(@"Switching API key for places response.");
    }
    NSString *URLStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%@&radius=%@&types=%@&key=%@",
                        latLong, self.searchRadius, types, googleAPIKey];
    
    
    // Make a server request to get the places data.
    if ([latLong length]) {
        
        // Prepare the URL and request.
        //NSString *completeURL = [NSString stringWithFormat:URLStr];
        NSURL *url = [[NSURL alloc]
                      initWithString:[URLStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
        // Make the network call.
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setTimeoutInterval:25.0];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        __weak LocationHelper *wSelf = self;
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // Success response.
            NSLog(@"Network-Response: %@", [operation responseString]);
            [wSelf parseGooglePlacesResponse:[operation responseString]];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // Network issues in response.
            NSHTTPURLResponse *httpResponse = [operation response];
            NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                 error);
            [self handleRequestError:error withHTTPResponse:httpResponse];
        }];
        [operation start];
        
    }else{
        NSLog(@"Warning! Cannot load user profile, user_uid not found!");
    }
}

- (void)handleRequestError:(NSError *)error
          withHTTPResponse:(NSHTTPURLResponse *)httpResponse{
    
    NSString *errStr = [[error userInfo] safeObjectForKey:@"NSLocalizedDescription"];
    if (errStr == nil) {
        NSString *errorStr = [NSString stringWithFormat:@"Server not reachable. Check internet connectivity. HTTP_%ld", (long)[httpResponse statusCode]];
        errStr = errorStr;
    }
    
    
    if (self.placesDelegate) {
        [self.placesDelegate locationHelper:self
                     placesAPIReceivedError:error
                                     forLat:self.currentLat
                                    andLong:self.currentLong];
        self.currentSearchRadiusIndex = 0;
    }
}

- (void)parseGooglePlacesResponse:(NSString *)responseString{
    NSLog(@"");
    
    BOOL isDataParsed = NO;
    NSData *JSONdata = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    if (JSONdata != nil) {
        NSMutableDictionary *resDic = [NSJSONSerialization
                                       JSONObjectWithData:JSONdata
                                       options:NSJSONReadingMutableContainers error:&error];
        if ([[resDic safeObjectForKey:@"status"] length] &&
            [[resDic safeObjectForKey:@"status"] caseInsensitiveCompare:@"ok"] == NSOrderedSame ) {
            
            id results = [resDic safeObjectForKey:@"results"];
            if ([results isKindOfClass:[NSArray class]] &&
                [results count]) {
                
                if (!self.currentPlaces) {
                    self.currentPlaces = [[NSMutableArray alloc] init];
                }
                
                for (NSDictionary *aPlace in results) {
                    GooglePlace *place = [[GooglePlace alloc] init];
                    [place parseWithDictionary:aPlace];
                    [self.currentPlaces addObject:place];
                }
                
                
                /*//  Sucess, places found
                if (self.placesDelegate) {
                    [self.placesDelegate locationHelper:self
                                      didFindMorePlaces:self.currentPlaces
                                                nearLat:self.currentLat
                                                andLong:self.currentLong];
                    
                    self.currentSearchRadiusIndex = 0;
                }*/
                if (self.placesDelegate) {
                    [self.placesDelegate locationHelper:self
                                          didFindPlaces:self.currentPlaces
                                                nearLat:self.currentLat
                                                andLong:self.currentLong];
                    
                    self.currentSearchRadiusIndex = 0;
                }
                
                // send background request to get more places data around.
                //**** [self getNearByAPIForLat:self.currentLat and:self.currentLong];
                
            }else{
                
                NSLog(@"No places found for lat-long: (%@-%@), radius: '%@'!", self.currentLat, self.currentLong, self.searchRadius);
                
                // No places returned, retry with increased radius.
                if (self.currentSearchRadiusIndex < [_searchRadiusArray count]) {
                    
                    self.currentSearchRadiusIndex++;
                    self.searchRadius = [_searchRadiusArray safeObjectAtIndex:self.currentSearchRadiusIndex];
                    
                    __weak LocationHelper *wSelf = self;
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                    {
                        [wSelf getPlaceNearlat:wSelf.currentLat andLong:wSelf.currentLong];
                    });
                }else{
                    
                    // No response found
                    if (self.placesDelegate) {
                        [self.placesDelegate locationHelper:self
                                     placesAPIReceivedError:nil
                                                     forLat:self.currentLat
                                                    andLong:self.currentLong];
                        
                        self.currentSearchRadiusIndex = 0;
                    }
                }
            }
            isDataParsed = YES;
        }else if ([[resDic safeObjectForKey:@"status"] length] &&
                  [[resDic safeObjectForKey:@"status"]
                   caseInsensitiveCompare:@"OVER_QUERY_LIMIT"] == NSOrderedSame ){
                      
                      NSString *message = [resDic safeObjectForKey:@"error_message"];
                      NSString *errorCode = [resDic safeObjectForKey:@"status"];
                      NSLog(@"***** Error Places API: '%@'. Switching Google API key", message);
                      if (_switchGoogleAPIKey == NO) {
                          isDataParsed = YES;
                          _switchGoogleAPIKey = YES;
                          [self getPlaceNearlat:self.currentLat andLong:self.currentLong];
                      }else{
                          isDataParsed = NO;
                          error = [NSError errorWithDomain:@"GooglePlacesErrorDomain"
                                                      code:-1
                                                  userInfo:@{NSLocalizedDescriptionKey: message,
                                                             NSLocalizedFailureReasonErrorKey: errorCode}];
                      }
                  }
        else{
            NSLog(@"Error-Log: %@", error);
        }
    }else{
        // Log reason for error.
        NSLog(@"Unable to parse response.");
    }
    
    if (!isDataParsed) {
        // TODO:-ksh Localize !
        
        if (self.placesDelegate) {
            [self.placesDelegate locationHelper:self
                         placesAPIReceivedError:error
                                         forLat:self.currentLat
                                        andLong:self.currentLong];
            
            self.currentSearchRadiusIndex = 0;
        }
    }
}


- (void)getNearByAPIForLat:(NSString *)lat and:(NSString *)longitude{
    
    self.isMoreAccuratePlacesAPI = YES;
    
    NSString *latLong = [NSString stringWithFormat:@"%@,%@", lat, longitude];
#if TARGET_IPHONE_SIMULATOR
    //if([lat doubleValue]==0 && [longitude doubleValue]==0){
    //latLong = [NSString stringWithFormat:@"%@,%@", @"28.51915",@"77.200835"];
    latLong = [NSString stringWithFormat:@"%@,%@", @"40.722388",@"-73.997641"];
    //}
#endif
    
    self.searchRadius = [_searchRadiusArray safeObjectAtIndex:self.currentSearchRadiusIndex]; // meters
    self.currentLat = lat;
    self.currentLong = longitude;
    
    NSString *types = @"";
    
    NSLog(@"Searching places with radius: '%@' ...",self.searchRadius);
    
    /*
     NSDictionary *params = @{@"location": latLong,
     @"radius" : self.searchRadius,
     @"types": types,
     @"key": kGooglePlacesAPIBrowserKey};*/
    
    //NSString *formURLParams = [NSString stringWithFormat:@"location=%@&radius=%@&types=food&sensor=true&key=AIzaSyAe93Ougvnt4rbCkHE_MrEEJGmUO93wD6o",
    //                         latLong, searchRadius, types, kGOOGLE_API_KEY];
    
    /// *NSString *encodedParam = AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(xml, NSUTF8StringEncoding); /
   
    /*
    NSString *URLStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%@&radius=%@&types=%@&key=%@",
                        latLong, self.searchRadius, types, kGooglePlacesAPIBrowserKey];*/
    
    types = @"establishment";
    NSString *keyword= @"";
    
    NSString *URLStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/radarsearch/json?location=%@&radius=%@&types=%@&keyword=%@&key=%@",
                        latLong, self.searchRadius, types, keyword ,kGooglePlacesAPIBrowserKey];
    
    // Make a server request to get the places data.
    if ([latLong length]) {
        
        // Prepare the URL and request.
        //NSString *completeURL = [NSString stringWithFormat:URLStr];
        NSURL *url = [[NSURL alloc]
                      initWithString:[URLStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
        // Make the network call.
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setTimeoutInterval:25.0];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        __weak LocationHelper *wSelf = self;
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // Success response.
            NSLog(@"Network-Response: %@", [operation responseString]);
            [wSelf parseGooglePlacesResponse:[operation responseString]];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // Network issues in response.
            NSHTTPURLResponse *httpResponse = [operation response];
            NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                 error);
            [self handleRequestError:error withHTTPResponse:httpResponse];
        }];
        [operation start];
        
    }else{
        NSLog(@"Warning! Cannot load user profile, user_uid not found!");
    }
}


- (void)getDetailsOfPlaceId:(NSString *)placeId{
    
#if TARGET_IPHONE_SIMULATOR
    //if([lat doubleValue]==0 && [longitude doubleValue]==0){
    placeId = [NSString stringWithFormat:@"%@", @"ChIJg9KYPZpZwokRmaQDxMj19HA"];
    //}
#endif
    
    NSLog(@"Searching detail with place_id: '%@' ...", placeId);
    
    /// *NSString *encodedParam = AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(xml, NSUTF8StringEncoding); /
    
    NSString *googleAPIKey = kGooglePlacesAPIBrowserKey2;
    if (_switchGoogleAPIKey) {
        googleAPIKey = kGooglePlacesAPIBrowserKey;
    }
    NSString *URLStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",
                        placeId, googleAPIKey];
    
    
    // Make a server request to get the places data.
    if ([placeId length]) {
        
        self.currentplaceId = placeId;
        
        // Prepare the URL and request.
        //NSString *completeURL = [NSString stringWithFormat:URLStr];
        NSURL *url = [[NSURL alloc]
                      initWithString:[URLStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
        // Make the network call.
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setTimeoutInterval:25.0];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        __weak LocationHelper *wSelf = self;
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            // Success response.
            NSLog(@"Network-Response: %@", [operation responseString]);
            [wSelf parseGooglePlaceDetailResponse:[operation responseString]
                                       forPlaceId:placeId];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // Network issues in response.
            NSHTTPURLResponse *httpResponse = [operation response];
            NSLog(@"Network-Response: HTTP-Status Code: %ld, Error: %@", (long)[httpResponse statusCode],
                 error);
            [self handleRequestError:error withHTTPResponse:httpResponse];
        }];
        [operation start];
        
    }else{
        NSLog(@"Warning! Cannot load user profile, user_uid not found!");
    }
}

- (void)parseGooglePlaceDetailResponse:(NSString *)responseString forPlaceId:(NSString *)placeId{
    NSLog(@"");
    
    BOOL isDataParsed = NO;
    NSData *JSONdata = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError = nil;
    
    if (JSONdata != nil) {
        NSMutableDictionary *resDic = [NSJSONSerialization
                                       JSONObjectWithData:JSONdata
                                       options:NSJSONReadingMutableContainers error:&jsonError];
        if ([[resDic safeObjectForKey:@"result"] count]) {
            
            id result = [resDic safeObjectForKey:@"result"];
            if ([result isKindOfClass:[NSDictionary class]] &&
                [result count]) {
                
                GooglePlaceDetail *placeDetail = [[GooglePlaceDetail alloc] init];
                [placeDetail parseWithDictionary:result];
                self.currentPlaceDetail = placeDetail;
                
                isDataParsed = YES;
                
                //  Sucess, places found
                if (self.placesDelegate) {
                    [self.placesDelegate locationHelper:self
                                         didPlaceDetail:placeDetail
                                             forPlaceId:placeId];
                    
                    self.currentSearchRadiusIndex = 0;
                }
            }
        }else if ([[resDic safeObjectForKey:@"status"] length] &&
                  [[resDic safeObjectForKey:@"status"]
                   caseInsensitiveCompare:@"OVER_QUERY_LIMIT"] == NSOrderedSame ){
                      
                      isDataParsed = YES;
                      _switchGoogleAPIKey = YES;
                      
                      NSString *message = [resDic safeObjectForKey:@"error_message"];
                      NSLog(@"***** Error Places API: '%@'. Switching Google API key", message);
                      [self getDetailsOfPlaceId:placeId];
                  }
        else{
            NSLog(@"Error-Log: %@", jsonError);
        }
    }else{
        // Log reason for error.
        NSLog(@"Unable to parse response.");
    }
    
    if (!isDataParsed) {
        // TODO:-ksh Localize !
        
        if (self.placesDelegate) {
            [self.placesDelegate locationHelper:self
                         placesAPIReceivedError:nil
                                         forLat:self.currentLat
                                        andLong:self.currentLong];
            
            self.currentSearchRadiusIndex = 0;
        }
    }
}

// Helper method from AFNetworking library 1.x
static NSString * AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()~";
    static NSString * const kAFCharactersToLeaveUnescaped = @"[].";
    
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}
@end
