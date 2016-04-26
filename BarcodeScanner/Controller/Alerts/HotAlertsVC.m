//
//  HotAlertsVC.m
//  BrandReporter
//
//  Created by Brahmasys on 21/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "HotAlertsVC.h"
#import "NVSlideMenuController.h"
#import "HotAlertsTableViewCell.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MyAccountVC.h"


@interface HotAlertsVC ()
{
    UIStoryboard *storyboard;
  
}
@end

@implementation HotAlertsVC

@synthesize  arrList;

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark FOR LEFT MENU ITEM

- (IBAction)profileButtonAction:(id)sender
{
    storyboard = [AppDelegate storyBoardType];
    MyAccountVC *objVC = (MyAccountVC*)[storyboard instantiateViewControllerWithIdentifier:@"MyAccountVCId"];
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    
}

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
    // Do any additional setup after loading the view.
    arrList = [[NSMutableArray alloc] init];
    [self getHotAlerts];

}


#pragma mark API

-(void)getHotAlerts
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading....", nil);
    
    NSURL *url = [[NSURL alloc] initWithString:KURLHotAlerts];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [arrList removeAllObjects];
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"success: %@", operation.responseString);
         
         NSString *jsonString = operation.responseString;
         NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
         
         NSError *jsonError = nil;
         if (JSONdata != nil) {
             
              NSMutableDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:JSONdata options:NSJSONReadingMutableContainers error:&jsonError];
             
             arrList = [dictTemp objectForKey:@"response"];
             NSLog(@"arrList %@",arrList);
             
             [tblList reloadData];
             
             
         }
         else
         {
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No records found!" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
//             [alert show];
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

#pragma mark Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 140;
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor grayColor]];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arrList count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"UserCell";
    
    HotAlertsTableViewCell *cell = (HotAlertsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        
      if (IS_IPHONE_6)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"HotAlertsTableViewCell_i6" owner:self options:nil];
            
        }
else
{
            nib = [[NSBundle mainBundle] loadNibNamed:@"HotAlertsTableViewCell" owner:self options:nil];
            
        }
        
        
        cell = [nib objectAtIndex:0];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    NSDictionary *dictTemp = [arrList objectAtIndex:indexPath.row];
    cell.lblTitle.text = [dictTemp valueForKey:@"title"];
    cell.lblSubTitle.text = [dictTemp valueForKey:@"message"];

        cell.imgProduct.layer.cornerRadius = 9.0f;
        cell.imgProduct.layer.borderWidth = 2.0f;
        cell.imgProduct.clipsToBounds = YES;
        cell.imgProduct.layer.borderColor = [UIColor whiteColor].CGColor;
        [cell.imgProduct setFrame:CGRectMake(10, 10, 50, 50)];
    
    [cell.imgProduct
     sd_setImageWithURL:[NSURL URLWithString:dictTemp[@"image"]]
     placeholderImage:[UIImage imageNamed:@"TestImg.png"]];
    [cell.btnShare addTarget:self
                     action:@selector(shareAction:)
           forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}

-(void)shareAction:(id)sender
{
    [self shareIt];
}

-(void)shareIt
{
    
    NSArray *activityItems= [NSArray arrayWithObjects:@"Share your experience with friends!", nil];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [activityVC setValue:@"Try out the Kalara Oil app" forKey:@"subject"];
    
    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed)
     {
         NSLog(@"Activity = %@",activityType);
         NSLog(@"Completed Status = %d",completed);
         
         if (completed)
         {
             
             UIAlertView *objalert = [[UIAlertView alloc]initWithTitle:Nil message:@"Successfully Shared" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [objalert show];
             objalert = nil;
         }
         else
         {
             
             UIAlertView *objalert = [[UIAlertView alloc]initWithTitle:Nil message:@"Unable To Share" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [objalert show];
             objalert = nil;
             
         }
     }];
    
    [self presentViewController:activityVC animated:YES completion:nil];
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
