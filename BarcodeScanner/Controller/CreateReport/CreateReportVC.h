//
//  CreateReportVC.h
//  Kalara
//
//  Created by Gauri Shankar on 17/09/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@class TPKeyboardAvoidingScrollView;

@interface CreateReportVC : UIViewController
{
    BOOL look;
    
}

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)newButtonAction:(id)sender;

@end
