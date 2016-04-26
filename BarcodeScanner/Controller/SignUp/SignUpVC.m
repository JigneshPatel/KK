//
//  SignUpVC.m
//  Kalara
//
//  Created by Gauri Shankar on 17/09/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "SignUpVC.h"
#import "NVSlideMenuController.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AppDelegate.h"
#import "MainHomeViewController.h"

@interface SignUpVC ()<UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UIImageView *imgUser;
    IBOutlet UITextField *txtUserName,*txtEmail,*txtPwd,*txtCPwd,*txtDOB,*txtMobile;
    IBOutlet UIDatePicker  *dataPickerView;

}

-(IBAction)picButtonAction:(id)sender;
-(IBAction)dobButtonAction:(id)sender;

@end

@implementation SignUpVC

@synthesize scrollView;


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark FOR LEFT MENU ITEM

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad {
    
    [self.navigationController setNavigationBarHidden:YES];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [scrollView contentSizeToFit];

    [dataPickerView         setHidden:YES];

}

-(IBAction)updateButtonAction:(id)sender
{
    [self submitRegister];
}

-(IBAction)cancelButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)picButtonAction:(id)sender
{
    NSLog(@"pic selection");
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @" Gallery", nil];
    [sheet showInView:self.view];
    [sheet setTag:1];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    
    if (buttonIndex==0)
    {
        UIImagePickerController *profile_ImagePicker = [[UIImagePickerController alloc]init];
        
        profile_ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [profile_ImagePicker setDelegate:self];
        
        [self presentViewController:profile_ImagePicker animated:YES completion:nil];
    }
    else if (buttonIndex==1)
    {
        
        UIImagePickerController *profile_ImagePicker = [[UIImagePickerController alloc]init];
        
        profile_ImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [profile_ImagePicker setDelegate:self];
        
        [self presentViewController:profile_ImagePicker animated:YES completion:nil];
    }
    
}

#pragma mark Image Picker Controller

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSData* data = UIImageJPEGRepresentation(image,0.1);
    
    
    imgUser.image = [UIImage imageWithData:data];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}


-(BOOL)isEmail:(NSString*)inputString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:txtEmail.text];
    
}

#pragma mark API


-(void)submitRegister
{
    
    //[[NSUserDefaults standardUserDefaults] setObject:@"10" forKey:kLoggedInUserId];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:KURLSignUp]];
    
    NSData *imageData = UIImageJPEGRepresentation(imgUser.image, 1.0);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"username"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",txtUserName.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"email"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",txtEmail.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"mobile"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",txtMobile.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"pass"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",txtPwd.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"dob"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",txtDOB.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    if ([[AppDelegate sharedAppDelegate].AD_noti_tid length] == 0) {
        // Set a dummy token, to allow login. if build is given from iOS7 sdk.
        [AppDelegate sharedAppDelegate].AD_noti_tid = [NSMutableString stringWithString:@"7a35a1696268a8c0c458b7ef6c35ce5d9c38978f57ea23f74e1d543a98e7fdd4"];
    }
    

    // add params (all params are strings)
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"gcm"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"%@\r\n",    [AppDelegate sharedAppDelegate].AD_noti_tid] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *imageName = [NSString stringWithFormat:@"%d",timestamp];
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@.png\r\n", @"image",imageName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Processing....", nil);
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if(data.length > 0)
         {
             //success
             NSLog(@"success");
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             NSError *jsonError = nil;
             if (data != nil) {
                 
                 
                 NSMutableDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                 
                 if ([[resDic objectForKey:@"result"] intValue] ==0)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please try again!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 else
                 {
                     NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

                     NSArray *arr = [resDic objectForKey:@"response"];
                     
                     NSDictionary *dict = [arr objectAtIndex:0];
                     
                     [defaults setObject:[dict valueForKey:@"username"] forKey:kLoggedInUserName];
                     [defaults setObject:[dict valueForKey:@"id"] forKey:kLoggedInUserId];
                     [defaults setObject:[dict valueForKey:@"email"] forKey:kLoggedInUserEmail];
                     [defaults setObject:[dict valueForKey:@"image"] forKey:kLoggedInUserImage];
                     [defaults setObject:[dict valueForKey:@"dob"] forKey:kLoggedInUserDOB];
                     
                     
                     [defaults synchronize];
                     
                     UIStoryboard *storyboard = [AppDelegate storyBoardType];
                     MainHomeViewController *objVC = (MainHomeViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MainHomeViewControllerId"];
                     [self.navigationController pushViewController:objVC animated:YES];
                     objVC = nil;
                 }
                 
             }
             else
             {
                 
                 
             }
         }
     }];
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
