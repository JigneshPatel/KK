//
//  HomeViewController.m
//  Kalara
//
//  Created by Gauri Shankar on 24/10/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "HomeViewController.h"
#import "ProductCollectionViewCell.h"
#import "CommentTableViewCell.h"
#import "NVSlideMenuController.h"
#import "AppDelegate.h"
#import "SignUpVC.h"
#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Constant.h"

@interface HomeViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    IBOutlet UIScrollView *scrollHome;
    IBOutlet UITableView *tblList;
    IBOutlet UICollectionView *collView;
    
    NSMutableArray *arrComment,*arrProduct;
    UIStoryboard *storyboard;
    IBOutlet UIWebView *webViewYT;

}

@end

@implementation HomeViewController

@synthesize dictInfo;

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


- (void)viewDidLoad {
    [self.navigationController setNavigationBarHidden:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [scrollHome setContentSize:CGSizeMake(320,1100)];
    
    [self playVideoWithId:@"https://www.youtube.com/watch?v=nkNxy6JOJ_E"];
    
    arrComment = [[NSMutableArray alloc] init];
    arrProduct = [[NSMutableArray alloc] init];

    [collView registerNib:[UINib nibWithNibName:@"ProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductCollectionViewCell"];

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

-(IBAction)newAccountButtonAction:(id)sender
{
    storyboard = [AppDelegate storyBoardType];
    SignUpVC *objVC = (SignUpVC*)[storyboard instantiateViewControllerWithIdentifier:@"SignUpVCId"];
    
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    
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


-(IBAction)signInButtonAction:(id)sender
{
    storyboard = [AppDelegate storyBoardType];
    ViewController *objVC = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewControllerId"];
    
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    
}

#pragma mark Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 105;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"CommentTableViewCell";
    
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil)
    {
       
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
   
    return cell;
    
}



#pragma mark Collectinview Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(92, 40);
    
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
    
    
    return 10;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCollectionViewCell" forIndexPath:indexPath];
    
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //intSelected = indexPath.item;
    
    
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
