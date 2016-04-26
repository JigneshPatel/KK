//
//  ForgotViewController.m
//  BrandReporter
//
//  Created by Gauri Shankar on 19/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "ForgotViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "AFNetworking.h"

@interface ForgotViewController ()<UITextFieldDelegate>
{
    UIStoryboard *storyboard;

}
@property (strong, nonatomic) IBOutlet UITextField *FPtextField;


@end

@implementation ForgotViewController

@synthesize scrollView;

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [scrollView contentSizeToFit];
    [self.navigationController setNavigationBarHidden:YES];

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate
{
    CGPoint offset = scrollView1.contentOffset;
    [scrollView1 setContentOffset:offset animated:NO];
    
    
}


-(IBAction)cancelButtonAction:(id)sender
{
    [self.FPtextField resignFirstResponder];

    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)submitButtonAction:(id)sender
{
    [self.FPtextField resignFirstResponder];
    
    if ([self.FPtextField.text length]>0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = NSLocalizedString(@"Sending Email", nil);
        
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@&&email=%@",KURLForgotPwd,self.FPtextField.text]];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError = nil;
            if (JSONdata != nil) {
                
                NSMutableDictionary *resDic = [NSJSONSerialization JSONObjectWithData:JSONdata options:NSJSONReadingMutableContainers error:&jsonError];
                NSLog(@"resDic %@",resDic);
                
                if ([[resDic objectForKey:@"result"] intValue] ==0) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Re-enter Email Address!" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
                    [alert show];
                }
                else
                {

                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Password recovery email sent to your email address" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
                    [alert show];
                    
                }
                
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid User id" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
                [alert show];
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            
            NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
            if (errStr==Nil) {
                errStr=@"Server not reachable. Check internet connectivity";
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errStr delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
            [alert show];
            
        }];
        
        [operation start];
    
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //[self.navigationController popViewControllerAnimated:YES];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
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
