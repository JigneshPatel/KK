//
//  GooglePlace.m
//  winkApp
//
//  Created by Temp on 28/12/14.
//  Copyright (c) 2014 kuriosthele. All rights reserved.
//

#import "GooglePlace.h"

@interface  GooglePlace ()

@property (nonatomic, readwrite) double latitude;
@property (nonatomic, readwrite) double longitude;
@property (nonatomic, strong, readwrite) NSArray *types;
@end

@implementation GooglePlace

- (void)parseWithDictionary:(NSDictionary *)dict{
    
    if ([dict isKindOfClass:[NSDictionary class]]) {
        
        self.geometry = [dict safeObjectForKey:@"geometry"];
        if (self.geometry) {
            id location = [self.geometry safeObjectForKey:@"location"];
            if (location &&
                [location isKindOfClass:[NSDictionary class]]) {
                
                id lat = [location safeObjectForKey:@"lat"];
                id lng = [location safeObjectForKey:@"lng"];
                
                if ([lat isKindOfClass:[NSNumber class]] &&
                    [lng isKindOfClass:[NSNumber class]]) {
                    
                    self.latitude = [((NSNumber *)lat) doubleValue];
                    self.longitude = [((NSNumber *)lng) doubleValue];
                }else if([lat isKindOfClass:[NSString class]] &&
                         [lng isKindOfClass:[NSString class]]){
                    
                    self.latitude = [((NSString *)lat) doubleValue];
                    self.longitude = [((NSString *)lng) doubleValue];
                }
            }
        }
        
        self.identifier = [dict safeObjectForKey:@"identifier"];
        
        self.name = [dict safeObjectForKey:@"name"];
        self.icon = [dict safeObjectForKey:@"icon"];

        self.placeId = [dict safeObjectForKey:@"place_id"];
        
        self.vicinity = [dict safeObjectForKey:@"vicinity"];
        
        self.types = [dict safeObjectForKey:@"types"];
    }else{
        
        NSLog(@"*** Error-Log: Cannot read Google Places response. Expecting 'NSDictionary' received %@", [dict class]);
    }
}
@end


@implementation GooglePlaceDetail


- (void)parseWithDictionary:(NSDictionary *)dict{
    
    if ([dict isKindOfClass:[NSDictionary class]]) {
        
        if ([[dict safeObjectForKey:@"place_id"] length] > 0) {
            self.google_id = [dict safeObjectForKey:@"id"];
            self.place_id = [dict safeObjectForKey:@"place_id"];
            self.vicinity = [dict safeObjectForKey:@"vicinity"];
            self.formatted_phone_number = [dict safeObjectForKey:@"formatted_phone_number"];
            self.formatted_address = [dict safeObjectForKey:@"formatted_address"];
            self.name = [dict safeObjectForKey:@"name"];
            self.icon = [dict safeObjectForKey:@"icon"];

            /*
            NSArray *address = [dict safeObjectForKey:@"address_components"];

                for (NSDictionary *component in address) {
                    if ([component safeObjectForKey:@"street_number"]) {
                        
                    }else if([component safeObjectForKey:@"route"]){
                    
                    }else if([component safeObjectForKey:@"street_number"]){
                        
                    }else if([component safeObjectForKey:@"street_number"]){
                        
                    }
                    

            }*/
            
        }
        
    }else{
        
        NSLog(@"*** Error-Log: Cannot read Google Places response. Expecting 'NSDictionary' received %@", [dict class]);
    }
}
@end

