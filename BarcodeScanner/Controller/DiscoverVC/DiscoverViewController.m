//
//  DiscoverViewController.m
//  Kalara
//
//  Created by Gauri Shankar on 25/10/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverCollectionViewCell.h"
#import "Constant.h"
#import "NVSlideMenuController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MyAccountVC.h"
#import "HotAlertsVC.h"


@interface DiscoverViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    IBOutlet UICollectionView *collView;
    
    NSMutableArray *arrProduct;
    UIStoryboard *storyboard;

}
@end

@implementation DiscoverViewController


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark FOR LEFT MENU ITEM
#pragma mark FOR LEFT MENU ITEM

- (IBAction)alertButtonAction:(id)sender
{
    storyboard = [AppDelegate storyBoardType];
    HotAlertsVC *objVC = (HotAlertsVC*)[storyboard instantiateViewControllerWithIdentifier:@"HotAlertsVCId"];
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    
}

- (IBAction)profileButtonAction:(id)sender
{
    storyboard = [AppDelegate storyBoardType];
    MyAccountVC *objVC = (MyAccountVC*)[storyboard instantiateViewControllerWithIdentifier:@"MyAccountVCId"];
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    
}
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
    
    arrProduct = [[NSMutableArray alloc] init];
    [collView registerNib:[UINib nibWithNibName:@"DiscoverCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DiscoverCollectionViewCell"];

    
    //[self getDiscoverList];
}

#pragma mark API

-(void)getDiscoverList
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading....", nil);
    
    NSURL *url = [[NSURL alloc] initWithString:KURLKnowledgeLib];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"success: %@", operation.responseString);
         
         [arrProduct removeAllObjects];
         
         NSString *jsonString = operation.responseString;
         NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
         
         NSError *jsonError = nil;
         if (JSONdata != nil) {
             
             NSArray *arrTemp = [NSJSONSerialization JSONObjectWithData:JSONdata options:NSJSONReadingMutableContainers error:&jsonError];
             

             NSLog(@"arrTemp %@",arrTemp);
             
             for(int i=0;i<[arrTemp count];i++)
             {
                 NSMutableDictionary *dictTemp = [arrTemp objectAtIndex:i];
                 
                 if([dictTemp[@"product"] isKindOfClass:[NSNull class]])
                 {
                     [dictTemp setObject:@"" forKey:@"product"];
                 }
                 
                 if([dictTemp[@"manufacture"] isKindOfClass:[NSNull class]])
                 {
                     [dictTemp setObject:@"" forKey:@"manufacture"];
                 }
                 
                 if([dictTemp[@"brand"] isKindOfClass:[NSNull class]])
                 {
                     [dictTemp setObject:@"" forKey:@"brand"];
                 }
                 
                 if([dictTemp[@"product"] isKindOfClass:[NSNull class]])
                 {
                     [dictTemp setObject:@"" forKey:@"product"];
                 }
                 
                 if([dictTemp[@"size"] isKindOfClass:[NSNull class]])
                 {
                     [dictTemp setObject:@"" forKey:@"size"];
                 }
                 
                 NSString *strImg = dictTemp[@"thumbnail"];
                 
                 NSArray *arrImg = [strImg componentsSeparatedByString:@"\""];
                 
                 if([arrImg count] >0)
                 {
                     NSString *strData = [arrImg objectAtIndex:1];
                     
                     [dictTemp setObject:strData forKey:@"thumbnail"];
                 }
                 else
                 {
                     [dictTemp setObject:@"" forKey:@"thumbnail"];
                     
                 }
                 [arrProduct addObject:dictTemp];
             }
             
             [collView reloadData];
             
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




#pragma mark Collectinview Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(150, 185);
    
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
    
    
    return 10;//arrProduct.count;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoverCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DiscoverCollectionViewCell" forIndexPath:indexPath];
    
//    NSDictionary *dictTemp = [arrProduct objectAtIndex:indexPath.row];
//    
//    cell.lblName.text = [dictTemp valueForKey:@"product"];
//    
//    [cell.imgView
//     sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dictTemp valueForKey:@"product_image"] objectAtIndex:0]]]
//     placeholderImage:[UIImage imageNamed:@"sample_image.jpg"]];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    storyboard = [AppDelegate storyBoardType];
    HomeViewController *objVC = (HomeViewController*)[storyboard instantiateViewControllerWithIdentifier:@"HomeViewControllerId"];
    //objVC.dictInfo = [arrProduct objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;

    
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
