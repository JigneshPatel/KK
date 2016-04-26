//
//  GooglePlace.h
//  winkApp
//
//  Created by Temp on 28/12/14.
//  Copyright (c) 2014 kuriosthele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+Safe.h"

@interface GooglePlace : NSObject

@property (nonatomic, strong) NSDictionary *geometry;
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *placeId;

@property (nonatomic, strong) NSString *icon;

/** @property vicinity
 * @brief The address of place. */
@property (nonatomic, strong) NSString *vicinity;

@property (nonatomic, readonly) NSArray *types;

- (void)parseWithDictionary:(NSDictionary *)dict;

/*
{
    "geometry": {
        "location": {
            "lat": -33.866786,
            "lng": 151.195633
        }
    },
    "icon": "http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
    "id": "3ef986cd56bb3408bc1cf394f3dad9657c1d30f6",
    "name": "Doltone House",
    "photos": [],
    "place_id": "ChIJ5xQ7szeuEmsRs6Kj7YFZE9k",
    "reference": "CnRwAAAAX_bvcSaAbkTekLdTTXn7SYsyeCQg0stI3rQ7OAIwhgCnnJp_mgw0Vidi5qXChvP8TPpoqzWbXc4ZKE1HEVHOirR2KcU1_CkMKmDttI9kKt7AauNZcOfejSb0aipewj4rCfUZcQ_oR60Zp26m_OyVkhIQCZaTaujjbghTnpcQrUG1ShoU-JnUwbyFF1TaFmEuTi2TyEdcxes",
    "scope": "GOOGLE",
    "types": [
              "restaurant",
              "food",
              "establishment"
              ],
    "vicinity": "48 Pirrama Road, Pyrmont"
},*/
@end







@interface GooglePlaceDetail : NSObject

@property (nonatomic, strong) NSString *google_id;
@property (nonatomic, strong) NSString *place_id;
@property (nonatomic, strong) NSString *vicinity;
@property (nonatomic, strong) NSString *formatted_phone_number;
@property (nonatomic, strong) NSString *formatted_address;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;


@property (nonatomic, strong) NSArray *placeTypes;

@property (nonatomic, strong) NSString *streetNum;
@property (nonatomic, strong) NSString *route;
@property (nonatomic, strong) NSString *locality;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;

/* @property isPlaceResidential
 * @brief Set from outside based on place types in places API. */
@property (nonatomic, readwrite) BOOL isPlaceResidential;

@property (nonatomic, strong) NSString *curLat;
@property (nonatomic, strong) NSString *curLong;

- (void)parseWithDictionary:(NSDictionary *)dict;

/*
"address_components": [],
"adr_address": "<span class=\"street-address\">Aadivasi Gowari Shahid Uddan Pul</span>, <span class=\"extended-address\">Lokamt Square, Dhantoli</span>, <span class=\"locality\">Nagpur</span>, <span class=\"region\">Maharashtra</span> <span class=\"postal-code\">440010</span>, <span class=\"country-name\">India</span>",
"formatted_address": "Aadivasi Gowari Shahid Uddan Pul, Lokamt Square, Dhantoli, Nagpur, Maharashtra 440010, India",
"formatted_phone_number": "098222 22523",
"geometry": {},
"icon": "http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png",
"id": "208f95f6debd8427e3dd89fe0f122228da6a5ff8",
"international_phone_number": "+91 98222 22523",
"name": "Jay Ganesh Bhojnalay",
"opening_hours": {},
"place_id": "ChIJW2zY1pPA1DsRvir6bWrHncE",
"reference": "CnRuAAAA9OPKjJkJAOaz45xkyYoBWHoRa69kHpLB_STAJpS4Z4fY0E_ee0UnoGLzUybP4XLav4MWAkdfsfLRTPPvEZHsFvfvpH5rabyU3RLgRYh6rE-xWamHG6uWTZf21jxwARK8LSquEMyP0ZmsXWB4hFKjYhIQcvJrChjm2yE5MfL8GnGcixoU4zS5wwCVEDSCIRuW7PHZZzKldyQ",
"scope": "GOOGLE",
"types": [
          "restaurant",
          "food",
          "establishment"
          ],
"url": "https://plus.google.com/105915646500020333243/about?hl=en-US",
"utc_offset": 330,
"vicinity": "Aadivasi Gowari Shahid Uddan Pul, Lokamt Square, Dhantoli, Nagpur"*/

@end
