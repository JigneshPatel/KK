//
//  CreateReportVC.m
//  Kalara
//
//  Created by Gauri Shankar on 17/09/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "CreateReportVC.h"
#import "NVSlideMenuController.h"
#import "MapSearchViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "DBOperations.h"
#import "Constant.h"
#import "AFNetworking.h"

@interface CreateReportVC ()<UITextFieldDelegate,UITextViewDelegate>
{
    UIStoryboard *storyboard;
    AppDelegate *delegate;
    IBOutlet UITextField *txtMft,*txtBrand,*txtProd,*txtSize,*txtBarCode;
    IBOutlet UITextView *txtViewComment;
    IBOutlet UIImageView *imgPic;
}

@end


@implementation CreateReportVC

@synthesize scrollView;

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    txtViewComment.layer.cornerRadius=10;
    [scrollView contentSizeToFit];
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    imgPic.layer.cornerRadius = imgPic.frame.size.width / 2;
    imgPic.clipsToBounds = YES;

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate
{
    CGPoint offset = scrollView1.contentOffset;
    [scrollView1 setContentOffset:offset animated:NO];
    
    
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

- (IBAction)backButtonAction:(id)sender
{
    [txtViewComment resignFirstResponder];
    [txtSize resignFirstResponder];
    [txtProd resignFirstResponder];
    [txtMft resignFirstResponder];
    [txtBrand resignFirstResponder];

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
