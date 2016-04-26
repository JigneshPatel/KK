//
//  MyReportObject.m
//  BrandReporter
//
//  Created by Gauri Shankar on 06/09/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "MyReportObject.h"

@implementation MyReportObject

@synthesize code = _code;
@synthesize image = _image;
@synthesize manft = _manft;
@synthesize brand = _brand;
@synthesize product = _product;
@synthesize size = _size;
@synthesize comment = _comment;
@synthesize address = _address;
@synthesize lat = _lat;
@synthesize longt = _longt;
@synthesize status = _status;
@synthesize date = _date;

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
            date:(NSString *)date
{
    self.code = code;
    self.image = image;
    self.manft = manft;
    self.brand = brand;
    self.product = product;
    self.size = size;
    self.comment = comment;
    self.address = address;
    self.lat = lat;
    self.longt = longt;
    self.status = status;
    self.date = date;
    
    return self;
}

@end
