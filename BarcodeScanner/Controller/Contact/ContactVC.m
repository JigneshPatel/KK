//
//  ContactVC.m
//  Kalara
//
//  Created by Gauri Shankar on 17/09/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "ContactVC.h"
#import "NVSlideMenuController.h"



@interface ContactVC ()<UITextFieldDelegate,UITextViewDelegate>
{
    IBOutlet UITextView *txtViewComment;
    IBOutlet UITextField *txtName,*txtEmail,*txtPhone;

}
@end

@implementation ContactVC


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    txtViewComment.layer.cornerRadius=10;

}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [txtViewComment setTextColor:[UIColor blackColor]];
    
    textView.text = @"";
    [textView becomeFirstResponder];
    
}

- (BOOL) textView: (UITextView*) textView
shouldChangeTextInRange: (NSRange) range
  replacementText: (NSString*) text
{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    [textView resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark FOR LEFT MENU ITEM

- (IBAction)backButtonAction:(id)sender {
    
    [txtViewComment resignFirstResponder];

    [txtName resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtPhone resignFirstResponder];

    
    if (!look)
    {
        [self.slideMenuController openMenuAnimated:YES completion:nil];
        
    }
    
    else
    {
        [self.slideMenuController closeMenuAnimated:YES completion:nil];
    }
    
    
    look=!look;
    
}

@end
