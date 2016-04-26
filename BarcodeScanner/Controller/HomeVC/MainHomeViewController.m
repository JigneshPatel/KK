//
//  MainHomeViewController.m
//  Kalara
//
//  Created by Gauri Shankar on 28/10/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "MainHomeViewController.h"
#import "GiftBroucherTableViewCell.h"
#import "NVSlideMenuController.h"
#import "AppDelegate.h"
#import "SignUpVC.h"
#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Constant.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "PCCollectionViewCell.h"


@interface MainHomeViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    IBOutlet UITableView *tblList;
    
    UIStoryboard *storyboard;
    AppDelegate *delegate;
        
    IBOutlet UIScrollView *scrollHome;
    IBOutlet UIWebView *webViewYT;
    IBOutlet UIView *viewLogin;
    NSMutableArray *arrProdImages,*arrOffers;
    IBOutlet UIImageView *imgOffer;
    IBOutlet UILabel *lblDsc,*lblNewOffer,*lblOldOffer,*lblTitleOffer,*lblDscOffer;
    
    IBOutlet UICollectionView *collView;
    NSMutableDictionary *dictFullData;
    int intImgStatus;
}


@end

@implementation MainHomeViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)leftArrowAction:(id)sender
{
    NSLog(@"leftArrowAction");
}

- (IBAction)rightArrowAction:(id)sender
{
    NSLog(@"rightArrowAction");

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


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    dictFullData = [[NSMutableDictionary alloc] init];
    arrOffers = [[NSMutableArray alloc]init];
    arrProdImages = [[NSMutableArray alloc]init];

    [collView registerNib:[UINib nibWithNibName:@"PCCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
   

    [scrollHome setContentSize:CGSizeMake(320,900)];
    
    
    [self getHomeDetails];

}

-(void)getHomeDetails
{
    NSLog(@"getHomeDetails");
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading....", nil);
    
    NSURL *url = [[NSURL alloc] initWithString:KURLHome];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"success: %@", operation.responseString);
         
         NSString *jsonString = operation.responseString;
         NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
         
         NSError *jsonError = nil;
         if (JSONdata != nil) {
             
             NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:JSONdata options:NSJSONReadingMutableContainers error:&jsonError];
             
             
             NSLog(@"dictTemp %@",dictTemp);
             
             if([dictTemp valueForKey:@"result"])
             {
                 NSLog(@"respone %@",[dictTemp valueForKey:@"response"]);
                 
                 NSArray *arrData = [dictTemp valueForKey:@"response"];
                 
                 dictFullData = [arrData objectAtIndex:0];
                 
                 NSLog(@"Description %@",dictFullData);
                 
                 [self playVideoWithId:[dictFullData valueForKey:@"video"]];
                 
                 arrProdImages = [dictFullData valueForKey:@"images"];
                 
                 [tblList reloadData];
                 [collView reloadData];
                 
             }
             
             
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No records found!" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
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

- (void)playVideoWithId:(NSString *)videoId {
    
    webViewYT.delegate = self;
    webViewYT.backgroundColor = [UIColor clearColor];
    webViewYT.opaque = NO;
    webViewYT.mediaPlaybackRequiresUserAction = NO;
    
    NSURL * url = [[NSURL alloc]initWithString:videoId];
    NSString *htmlString =[NSString stringWithFormat:@"<object width='320' height='172'><param name='movie' value='%@'></param><param name='wmode' value='transparent'></param><embed src='%@'type='application/x-shockwave-flash' wmode='transparent' width='320' height='170'></embed></object>",url,url];
    [webViewYT loadHTMLString:htmlString baseURL:nil];
    
    
    
}

-(IBAction)fbButtonAction:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
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

             }
         }];
        
    }
}


-(IBAction)newAccountButtonAction:(id)sender
{
    storyboard = [AppDelegate storyBoardType];
    SignUpVC *objVC = (SignUpVC*)[storyboard instantiateViewControllerWithIdentifier:@"SignUpVCId"];
    
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    
}

-(IBAction)signInButtonAction:(id)sender
{
    storyboard = [AppDelegate storyBoardType];
    ViewController *objVC = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewControllerId"];
    
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    
}

-(IBAction)joinNowButtonAction:(id)sender
{
    storyboard = [AppDelegate storyBoardType];
    SignUpVC *objVC = (SignUpVC*)[storyboard instantiateViewControllerWithIdentifier:@"SignUpVCId"];
    
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    
}

#pragma mark Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 136;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"GiftBroucherTableViewCell";
    
    GiftBroucherTableViewCell *cell = (GiftBroucherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GiftBroucherTableViewCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.lblTitle.text = [dictFullData valueForKey:@"Offer Title"];
    cell.lblDsc.text = [dictFullData valueForKey:@"Offer_Description"];
    cell.lblNew.text = [dictFullData valueForKey:@"MRP"];
    cell.lblOld.text = [dictFullData valueForKey:@"Offer_Price"];
    
    [cell.imgProduct
     sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dictFullData valueForKey:@"offer_image"]]]
     placeholderImage:[UIImage imageNamed:@"TestImg.png"]];
    
    return cell;
    
}


#pragma mark Collectinview Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(320, 170);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 4.0;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 4.5;
    
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return arrProdImages.count;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    
    cell.lblName.text = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.";
    
    [cell.imgView
     sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrProdImages objectAtIndex:indexPath.row]]]
     placeholderImage:[UIImage imageNamed:@"TestImg.png"]];
    
    
    return cell;
    
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
