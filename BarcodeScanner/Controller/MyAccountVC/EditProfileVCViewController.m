//
//  EditProfileVCViewController.m
//  BrandReporter
//
//  Created by Gauri Shankar on 16/09/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "EditProfileVCViewController.h"

#import "MyAccountVC.h"
#import "NVSlideMenuController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface EditProfileVCViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
{
    IBOutlet UITextField *lblEmail,*lblName;
    IBOutlet UIImageView *imgPic,*imgAvt;
    IBOutlet UILabel *lblAvt;
    IBOutlet UIButton *btnPic,*btnSave;
    NSURLConnection *serverConnection;
    NSMutableData *returnData;
}

-(IBAction)picButtonAction:(id)sender;


@end

@implementation EditProfileVCViewController

@synthesize scrollView,dictData;

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark FOR LEFT MENU ITEM

- (IBAction)cancelButtonAction:(id)sender {
    
    [lblEmail resignFirstResponder];
    [lblName resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    imgPic.layer.cornerRadius = imgPic.frame.size.width / 2;
    imgPic.clipsToBounds = YES;
    
    //[scrollView contentSizeToFit];
    
    lblName.text = [dictData objectForKey:@"username"];
    lblEmail.text = [dictData objectForKey:@"email"];
    [lblName setUserInteractionEnabled:NO];
    [imgPic
     sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:kLoggedInUserImage]]
     placeholderImage:[UIImage imageNamed:@"profileimg@2x.png"]];
}


- (IBAction)saveButtonAction:(id)sender
{
    [lblEmail resignFirstResponder];

    [self updateUserProfile];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)picButtonAction:(id)sender
{
    NSLog(@"pic selection");
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery", nil];
    [sheet showInView:self.view];
    [sheet setTag:1];
}

-(void)hideAvt
{
    [imgAvt setHidden:YES];
    [lblAvt setHidden:YES];
    
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
        profile_ImagePicker.editing = YES;

        [self presentViewController:profile_ImagePicker animated:YES completion:nil];
    }
    else if (buttonIndex==1)
    {
        
        UIImagePickerController *profile_ImagePicker = [[UIImagePickerController alloc]init];
        
        profile_ImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [profile_ImagePicker setDelegate:self];
        profile_ImagePicker.editing = YES;

        [self presentViewController:profile_ImagePicker animated:YES completion:nil];
    }
    
}

#pragma mark Image Picker Controller

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSData* data = UIImageJPEGRepresentation(image,0.1);
    
    if(image != nil)
    {
        [self hideAvt];
    }
    
    imgPic.image = [UIImage imageWithData:data];

    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(BOOL)isEmail:(NSString*)inputString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:lblEmail.text];
    
}

#pragma mark API

/*
-(void)updateUserProfile
{
    
    if(![self isEmail:lblEmail.text])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please provide valid email address!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert=nil;
        
    }
    else if([lblEmail.text length]==0 || [lblName.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter all the information!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert=nil;

    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = NSLocalizedString(@"Updating....", nil);
        
        NSString *postPath = [NSString stringWithFormat:@"%@&&email=%@&&username=%@",KURLProfileEdit,lblEmail.text,lblName.text];
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:postPath parameters:nil
                                                                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                        
                                        {
                                            
                                            [formData appendPartWithFileData:nil//UIImagePNGRepresentation(imgPic.image)
                                                                        name:@"fielContent"
                                                                    fileName:@"user.png"
                                                                    mimeType:@"image/png"];
                                            
                                        } error:nil] ;
        
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"success: %@", operation.responseString);
            
            NSString *jsonString = operation.responseString;
            NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError = nil;
            if (JSONdata != nil)
            {
                
                
                NSMutableDictionary *resDic = [NSJSONSerialization JSONObjectWithData:JSONdata options:NSJSONReadingMutableContainers error:&jsonError];
                
                NSLog(@"resDic %@",resDic);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User profile updated!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag=10;
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Not able to update profile!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
*/


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10)
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
}

#pragma mark API

-(void)updateUserProfile
{
    
    if(![self isEmail:lblEmail.text])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please provide valid email address!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert=nil;
        
    }
    else if([lblEmail.text length]==0 || [lblName.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter all the information!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        alert=nil;
        
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = NSLocalizedString(@"Updating....", nil);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:KURLEditProfile]];
        
        NSData *imageData = UIImageJPEGRepresentation(imgPic.image, 1.0);
        
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
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",lblName.text] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // add params (all params are strings)
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"email"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",lblEmail.text] dataUsingEncoding:NSUTF8StringEncoding]];
       
        // add params (all params are strings)
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"id"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",[[NSUserDefaults standardUserDefaults] valueForKey:kLoggedInUserId]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // add params (all params are strings)
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"password"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",[[NSUserDefaults standardUserDefaults] valueForKey:kLoggedInUserPwd]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
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
                     
                     NSLog(@"resDic %@",resDic);
                     
                     if ([[resDic objectForKey:@"result"] intValue] ==0)
                     {
                         
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please try again!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alert show];
                     }
                     else
                     {
                         
                         NSArray *arr = [resDic objectForKey:@"response"];
                         
                         NSDictionary *dict = [arr objectAtIndex:0];
                         
                         NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                         
                         [defaults setObject:[dict objectForKey:@"user_name"] forKey:kLoggedInUserName];
                         [defaults setObject:[dict valueForKey:@"image"] forKey:kLoggedInUserImage];
                         [defaults setObject:[dict valueForKey:@"email"] forKey:kLoggedInUserEmail];
                         
                         [imgPic
                          sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"image"]]
                          placeholderImage:[UIImage imageNamed:@"profileimg@2x.png"]];
                         
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User profile updated!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                         alert.tag=10;
                         [alert show];
                         
                     }
                     
                     
                 } else {
                     
                     
                 }
                 
                
             }
         }];
        
      
    }
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
