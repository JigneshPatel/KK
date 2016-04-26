//
//  ViewController.m
//  Kalara
//
//  Created by Gauri Shankar on 16/09/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "ViewController.h"
#import "SignUpVC.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "ForgotViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MainHomeViewController.h"

@interface ViewController ()
{
    UIStoryboard *storyboard;
    IBOutlet UITextField *txtUserName,*txtPassword;

}
@end

@implementation ViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark FOR LEFT MENU ITEM

- (IBAction)backButtonAction:(id)sender {
    
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

- (void)viewDidLoad {
    
    [self.navigationController setNavigationBarHidden:YES];

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)newAccountButtonAction:(id)sender
{
    storyboard = [AppDelegate storyBoardType];
    SignUpVC *objVC = (SignUpVC*)[storyboard instantiateViewControllerWithIdentifier:@"SignUpVCId"];
    
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    
}

-(IBAction)facebookButtonAction:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login
     logInWithReadPermissions: @[@"email",@"public_profile"]
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             
             [self fetchUserInfo];
         }
     }];
}

-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id,name,first_name, last_name, email, birthday,location"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"result : %@",result);
                 
                 [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"id"] forKey:kLoggedInUserId];
                 
                 [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"name"] forKey:kLoggedInUserName];

                 [[NSUserDefaults standardUserDefaults] setObject:[result valueForKey:@"email"] forKey:kLoggedInUserEmail];
                 
             }
         }];
        
    }
}


-(IBAction)forgotPwdButtonAction:(id)sender
{
    
    storyboard = [AppDelegate storyBoardType];
    ForgotViewController *objVC = (ForgotViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ForgotViewControllerId"];
    
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
}

-(IBAction)rememberMeButtonAction:(id)sender
{
    
}


-(IBAction)signInButtonAction:(id)sender
{
    [self MoveToUserProfileView];
    
    
}

-(void)MoveToUserProfileView
{
    
    [txtUserName resignFirstResponder];
    if (txtUserName.text!=Nil) {
        if ([txtUserName.text length]>0)
        {
            NSLog(@"%@ is a User id",txtUserName.text);
            if (txtPassword.text!=Nil) {
                if ([txtPassword.text length]>0)
                {
                    NSLog(@"%@ is a Password",txtPassword.text);
                    [self loginValidation];
                }
                else{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter the Password" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter the Password" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter  username" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter username" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        
    }
}


#pragma mark LOGIN API

-(void)loginValidation
{
    
    if ([[AppDelegate sharedAppDelegate].AD_noti_tid length] == 0) {
        // Set a dummy token, to allow login. if build is given from iOS7 sdk.
        [AppDelegate sharedAppDelegate].AD_noti_tid = [NSMutableString stringWithString:@"7a35a1696268a8c0c458b7ef6c35ce5d9c38978f57ea23f74e1d543a98e7fdd4"];
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Processing Login", nil);
    
    txtUserName.text = [txtUserName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //username,password
    //[[NSUserDefaults standardUserDefaults] setObject:@"10" forKey:kLoggedInUserId];
    
    

    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@&&email=%@&&pass=%@&&gcm=%@",KURLSignIn,txtUserName.text,txtPassword.text,[AppDelegate sharedAppDelegate].AD_noti_tid]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"success: %@", operation.responseString);
        NSString *jsonString = operation.responseString;
        NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError = nil;
        if (JSONdata != nil) {
            
            
            NSMutableDictionary *DiccL = [NSJSONSerialization JSONObjectWithData:JSONdata options:NSJSONReadingMutableContainers error:&jsonError];
            
            NSLog(@"Dicc: %@", DiccL);
            
            
            if ([[DiccL objectForKey:@"result"] intValue] ==0)
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please try again!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                
                NSLog(@"User is logged in");
                
                NSArray *arr = [DiccL objectForKey:@"response"];
                
                NSDictionary *dict = [arr objectAtIndex:0];
                
                [defaults setObject:[dict valueForKey:@"username"] forKey:kLoggedInUserName];
                [defaults setObject:txtPassword.text forKey:kLoggedInUserPwd];
                [defaults setObject:[dict valueForKey:@"id"] forKey:kLoggedInUserId];
                [defaults setObject:[dict valueForKey:@"email"] forKey:kLoggedInUserEmail];
                [defaults setObject:[dict valueForKey:@"image"] forKey:kLoggedInUserImage];
                [defaults setObject:[dict valueForKey:@"dob"] forKey:kLoggedInUserDOB];

                
                [defaults synchronize];
                
                storyboard = [AppDelegate storyBoardType];
                MainHomeViewController *objVC = (MainHomeViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MainHomeViewControllerId"];
                [self.navigationController pushViewController:objVC animated:YES];
                objVC = nil;
                
                
                //[self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error: %@",  operation.responseString);
        
        
        NSString *errStr=[[error userInfo] objectForKey:@"NSLocalizedDescription"];
        if (errStr==Nil) {
            errStr=@"Server not reachable";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errStr delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
        [alert show];
        
        
    }];
    
    [operation start];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
