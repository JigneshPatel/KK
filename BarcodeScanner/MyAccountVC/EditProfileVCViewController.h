//
//  EditProfileVCViewController.h
//  BrandReporter
//
//  Created by Gauri Shankar on 16/09/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKeyboardAvoidingScrollView;

@interface EditProfileVCViewController : UIViewController
{
    BOOL look;
    NSDictionary *dictData;
}

@property (strong, nonatomic) NSDictionary *dictData;

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

- (IBAction)saveButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;


@end
