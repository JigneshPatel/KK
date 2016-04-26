//
//  CreatReportVC.m
//  BrandReporter
//
//  Created by Gauri Shankar on 24/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "CreatReportVC.h"
#import "NVSlideMenuController.h"
#import "MapSearchViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "DBOperations.h"
#import "ViewController.h"

@interface CreatReportVC ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    UIStoryboard *storyboard;
    AppDelegate *delegate;
    IBOutlet UITextField *txtMft,*txtBrand,*txtProd,*txtSize,*txtBarCode;
    IBOutlet UITextView *txtViewComment;
    IBOutlet UIImageView *imgPic;
}

@end

@implementation CreatReportVC

@synthesize scrollView;

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark FOR LEFT MENU ITEM

- (IBAction)backButtonAction:(id)sender {
    
   
        [txtViewComment resignFirstResponder];
        [txtSize resignFirstResponder];
        [txtProd resignFirstResponder];
        [txtMft resignFirstResponder];
        [txtBrand resignFirstResponder];
        
      
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad
{
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [scrollView contentSizeToFit];
    
    
    txtViewComment.layer.cornerRadius=10;
    
    imgPic.layer.cornerRadius = imgPic.frame.size.width / 2;
    imgPic.clipsToBounds = YES;
    //    imgPic.layer.borderWidth = 3.0f;
    //    imgPic.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    NSLog(@"delegate.dictRecord Image %@",[delegate.dictRecord valueForKey:@"Image"]);
    
    NSArray *arrImg = [delegate.dictRecord valueForKey:@"Image"];
    
    if([arrImg count]>0)
    {
        imgPic.image = [[arrImg objectAtIndex:0] valueForKey:@"Img"];
    }
    else
    {
        imgPic.image = [UIImage imageNamed:@"no_image.png"];
    }
    
    txtBarCode.text = [delegate.dictRecord valueForKey:@"BarCode"];
    
    [self performSelector:@selector(InsertView)  withObject:nil afterDelay:1.0];
    
    if(delegate.intEditReport>0)
    {
        
        NSDictionary *dict=  delegate.dictRecord;
        
        txtBarCode.text = [dict valueForKey:@"barcode"];
        [txtViewComment setText:[dict valueForKey:@"comment"]];
        [txtSize setText:[dict valueForKey:@"size"]];
        [txtProd setText:[dict valueForKey:@"product"]];
        [txtMft setText:[dict valueForKey:@"manufacturer"]];
        [txtBrand setText:[dict valueForKey:@"brand"]];
        
        NSLog(@"Image %@",[dict valueForKey:@"Image"]);
        
    }
    else
    {
        if([[delegate.dictRecord valueForKey:@"BarCode"] length]>0)
        {
            //[self barCodeValidation];
        }
    }
    
}



-(void)InsertView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate
{
    CGPoint offset = scrollView1.contentOffset;
    [scrollView1 setContentOffset:offset animated:NO];
    
    
}


- (IBAction)newButtonAction:(id)sender
{
    [delegate.dictRecord setValue:txtBarCode.text forKey:@"BarCode"];
    [delegate.dictRecord setValue:txtMft.text forKey:@"Manufacture"];
    [delegate.dictRecord setValue:txtBrand.text forKey:@"Brand"];
    [delegate.dictRecord setValue:txtProd.text forKey:@"Product"];
    [delegate.dictRecord setValue:txtSize.text forKey:@"Size"];
    [delegate.dictRecord setValue:txtViewComment.text forKey:@"Comment"];

    //NSLog(@"delegate.dictRecord %@",delegate.dictRecord);
    
    storyboard = [AppDelegate storyBoardType];
    
    MapSearchViewController *objVC = (MapSearchViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MapSearchViewControllerId"];
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
