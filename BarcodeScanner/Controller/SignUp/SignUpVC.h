//
//  SignUpVC.h
//  Kalara
//
//  Created by Gauri Shankar on 17/09/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKeyboardAvoidingScrollView;

@interface SignUpVC : UIViewController
{
    BOOL look;
    
}

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

-(IBAction)updateButtonAction:(id)sender;
-(IBAction)cancelButtonAction:(id)sender;

@end
