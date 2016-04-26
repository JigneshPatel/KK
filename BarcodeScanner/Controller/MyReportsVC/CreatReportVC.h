//
//  CreatReportVC.h
//  BrandReporter
//
//  Created by Gauri Shankar on 24/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@class TPKeyboardAvoidingScrollView;

@interface CreatReportVC : UIViewController
{
    BOOL look;
    
}

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)newButtonAction:(id)sender;

@end
