//
//  MyAccountVC.h
//  BrandReporter
//
//  Created by Gauri Shankar on 21/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKeyboardAvoidingScrollView;

@interface MyAccountVC : UIViewController
{
    BOOL look;
    
}

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)logOutButtonAction:(id)sender;

@end
