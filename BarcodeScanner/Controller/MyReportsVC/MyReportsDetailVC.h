//
//  MyReportsDetailVC.h
//  BrandReporter
//
//  Created by Gauri Shankar on 01/08/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyReportsDetailVC : UIViewController
{
    NSDictionary *dictReport;
    int intRow;
}

@property (strong, nonatomic) NSDictionary *dictReport;
@property int intRow;

@end
