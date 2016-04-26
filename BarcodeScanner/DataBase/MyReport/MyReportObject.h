//
//  MyReportObject.h
//  BrandReporter
//
//  Created by Gauri Shankar on 06/09/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyReportObject : NSObject
{
    NSString *_code,*_image,*_manft,*_brand,*_product,*_size,*_comment,*_address,*_lat,*_longt,*_status,*_date;
}

@property (nonatomic, copy)  NSString *code,*image,*manft,*brand,*product,*size,*comment,*address,*lat,*longt,*status,*date;

-(id)initWithcode:(NSString *)code
         image:(NSString *)image
             manft:(NSString *)manft
         brand:(NSString *)brand
              product:(NSString *)product
           size:(NSString *)size
          comment:(NSString *)comment
             address:(NSString *)address
          lat:(NSString *)lat
             longt:(NSString *)longt
              status:(NSString *)status
            date:(NSString *)date;

@end
