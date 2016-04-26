//
//  ForgotViewController.h
//  BrandReporter
//
//  Created by Gauri Shankar on 19/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
@class TPKeyboardAvoidingScrollView;

@interface ForgotViewController : UIViewController

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;


-(IBAction)submitButtonAction:(id)sender;

@end
