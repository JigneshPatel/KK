//
//  MyAccountVC.m
//  BrandReporter
//
//  Created by Gauri Shankar on 21/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "MyAccountVC.h"
#import "NVSlideMenuController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "EditProfileVCViewController.h"

@interface MyAccountVC ()<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
{
    IBOutlet UITextField *lblEmail,*lblName,*txtDOB;
    IBOutlet UIImageView *imgPic,*imgAvt;
    IBOutlet UILabel *lblAvt;
    IBOutlet UIButton *btnPic,*btnSave;
    UIStoryboard *storyboard;

}

-(IBAction)picButtonAction:(id)sender;

@end

@implementation MyAccountVC

@synthesize scrollView;

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark FOR LEFT MENU ITEM

- (IBAction)backButtonAction:(id)sender
{

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


- (void)viewWillAppear:(BOOL)animated
{

    NSLog(@"img %@ un %@ email %@",[[NSUserDefaults standardUserDefaults] valueForKey:kLoggedInUserImage],[[NSUserDefaults standardUserDefaults] valueForKey:kLoggedInUserName],[[NSUserDefaults standardUserDefaults] valueForKey:kLoggedInUserEmail]);
    
    lblName.text = [[NSUserDefaults standardUserDefaults] valueForKey:kLoggedInUserName];
    lblEmail.text = [[NSUserDefaults standardUserDefaults] valueForKey:kLoggedInUserEmail];
    txtDOB.text = [[NSUserDefaults standardUserDefaults] valueForKey:kLoggedInUserDOB];
    
    [imgPic
     sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:kLoggedInUserImage]]
     placeholderImage:[UIImage imageNamed:@"profileimg@2x.png"]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    imgPic.layer.cornerRadius = imgPic.frame.size.width / 2;
    imgPic.clipsToBounds = YES;

    [lblEmail setUserInteractionEnabled:NO];
    [lblName setUserInteractionEnabled:NO];
    [btnPic setUserInteractionEnabled:NO];

    //[scrollView contentSizeToFit];

    //[self getUserProfile];

   
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView1 willDecelerate:(BOOL)decelerate
{
    CGPoint offset = scrollView1.contentOffset;
    [scrollView1 setContentOffset:offset animated:NO];
    
    
}

- (IBAction)editProfileButtonAction:(id)sender
{
    
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc] init];
    
    [resDic setValue:lblName.text forKey:@"username"];
    [resDic setValue:lblEmail.text forKey:@"email"];
    
    storyboard = [AppDelegate storyBoardType];
    EditProfileVCViewController *objVC = (EditProfileVCViewController*)[storyboard instantiateViewControllerWithIdentifier:@"EditProfileVCViewControllerId"];
    objVC.dictData = resDic;
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;

    
}

- (IBAction)logOutButtonAction:(id)sender
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:kLoggedInUserId];
    [defaults setObject:@"" forKey:kLoggedInUserName];
    [defaults setObject:@"" forKey:kLoggedInUserEmail];
    
    
   storyboard = [AppDelegate storyBoardType];
    ViewController *objView = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewControllerId"];
    
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
    [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
}



#pragma mark API

-(void)getUserProfile
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading....", nil);
    
    //http://brandreporter.co/webservice/brandreporter.php?action=profile&&userId=1
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@&&userId=%@",KURLProfile,[[NSUserDefaults standardUserDefaults] objectForKey:kLoggedInUserId]]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"success: %@", operation.responseString);
        
        NSString *jsonString = operation.responseString;
        NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *jsonError = nil;
        if (JSONdata != nil) {
            
            NSArray *arrResp = [NSJSONSerialization JSONObjectWithData:JSONdata options:NSJSONReadingMutableContainers error:&jsonError];
            
            NSLog(@"resDic %@",arrResp);
           
            NSMutableDictionary *resDic = [arrResp objectAtIndex:0];
            
            lblName.text = [resDic objectForKey:@"username"];
            lblEmail.text = [resDic objectForKey:@"email"];
            
        }
        
        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
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
