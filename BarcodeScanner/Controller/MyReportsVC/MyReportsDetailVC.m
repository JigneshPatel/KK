//
//  MyReportsDetailVC.m
//  BrandReporter
//
//  Created by Gauri Shankar on 01/08/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "MyReportsDetailVC.h"
#import "Constant.h"
#import "MapDetailVC.h"
#import "AppDelegate.h"
#import "SnapVC.h"
#import "DBOperations.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MRDCollectionViewCell.h"


@interface MyReportsDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
        UIStoryboard *storyboard;
        AppDelegate *delegate;
    
    IBOutlet UIImageView *imgViewReport;
    IBOutlet UILabel *lblReporter,*lblReportDate,*lblReportStatus,*lblBarCode,*lblMft,*lblBrand,*lblProduct,*lblSize,*lblAdd,*lblComment;
    
    IBOutlet UICollectionView *collView;
    IBOutlet UIImageView *imgViewFullImage;
    IBOutlet UIView *viewFull;
    IBOutlet UITextView *txtComment;
    NSMutableArray *arrImages;
    
}

- (IBAction)backButtonAction:(id)sender;
- (IBAction)mapButtonAction:(id)sender;
- (IBAction)editButtonAction:(id)sender;
- (IBAction)deleteButtonAction:(id)sender;
- (IBAction)crossButtonAction:(id)sender;

@end

@implementation MyReportsDetailVC

@synthesize dictReport;

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



- (IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    [collView registerNib:[UINib nibWithNibName:@"MRDCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MRDCollectionViewCell"];

    [viewFull setHidden:YES];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];

    NSLog(@"dictReport %@",dictReport);
    
    imgViewReport.layer.cornerRadius = imgViewReport.frame.size.width / 2;
    imgViewReport.clipsToBounds = YES;
    imgViewReport.layer.borderWidth = 2.0f;
    imgViewReport.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    lblReporter.text = [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedInUserName];
    lblReportDate.text = [dictReport valueForKey:@"created_date"];

    lblReportStatus.text = [dictReport valueForKey:@"status"];
    lblBarCode.text = [dictReport valueForKey:@"barcode"];
    lblMft.text = [dictReport valueForKey:@"manufacturer"];
    lblBrand.text = [dictReport valueForKey:@"brand"];
    lblProduct.text = [dictReport valueForKey:@"product"];
    lblSize.text = [dictReport valueForKey:@"size"];
    lblAdd.text = [dictReport valueForKey:@"address"];
    txtComment.text = [dictReport valueForKey:@"comment"];
    
    //imgViewReport.image = [AppDelegate getImage:[dictReport valueForKey:@"image"] fromFolder:@""];
    
    arrImages = [[NSMutableArray alloc] init];
    
    arrImages = [dictReport valueForKey:@"image"];
    
    [imgViewReport
     sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrImages objectAtIndex:0]]]
     placeholderImage:[UIImage imageNamed:@"TestImg.png"]];
    
    [collView reloadData];
    
}

- (IBAction)mapButtonAction:(id)sender
{
    NSLog(@"load map view %@",[dictReport valueForKey:@"geo"]);
   
    storyboard = [AppDelegate storyBoardType];
    
    MapDetailVC *objVC = (MapDetailVC*)[storyboard instantiateViewControllerWithIdentifier:@"MapDetailVCId"];
    objVC.strLatLong = [NSString stringWithFormat:@"%@",[dictReport valueForKey:@"geo"]];
    
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    

  
}

- (IBAction)deleteButtonAction:(id)sender
{
    NSLog(@"deleteButtonAction");
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10)
    {
    if(buttonIndex == 0)
    {
        NSLog(@"editButtonAction %@",[dictReport valueForKey:@"id"]);
        
        delegate.intEditReport = [[dictReport valueForKey:@"id"] intValue];
        
        delegate.dictRecord = (NSMutableDictionary*)dictReport;
        
        storyboard = [AppDelegate storyBoardType];
        SnapVC *objVC = (SnapVC*)[storyboard instantiateViewControllerWithIdentifier:@"SnapVCId"];
        [self.navigationController pushViewController:objVC animated:YES];
        objVC = nil;
    }
    else if(buttonIndex == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to delete this report?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
        alert.tag = 11;
        [alert show];
    }
    }
    else
    {
        if(buttonIndex == 0)
        {
            [self deleteMyReport]; 
        }
    }
}

- (IBAction)editButtonAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to update this report?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Edit",@"Delete",@"Cancel", nil];
    alert.tag = 10;
    [alert show];
    
}


#pragma mark API

-(void)deleteMyReport
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Deleting report....", nil);
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@",KURLDeleteReport,[dictReport valueForKey:@"id"]]];
    
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
             
             
             NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:JSONdata options:NSJSONReadingMutableContainers error:&jsonError];
             
             NSLog(@"resDic %@",resDic);
             
             if ([resDic objectForKey:@"result"] ==0)
             {
                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Try Again!" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
                                      [alert show];
             }
             else
             {
                 [self.navigationController popViewControllerAnimated:YES];


             }
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
    
    return CGSizeMake(300, 100);
    
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
    
    
    return arrImages.count;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MRDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MRDCollectionViewCell" forIndexPath:indexPath];
    
    [cell.imgView
     sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrImages objectAtIndex:indexPath.row]]]
     placeholderImage:[UIImage imageNamed:@"sample_image.jpg"]];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [imgViewFullImage
     sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrImages objectAtIndex:indexPath.row]]]
     placeholderImage:[UIImage imageNamed:@"sample_image.jpg"]];
    
    [viewFull setHidden:NO];

}

- (IBAction)crossButtonAction:(id)sender
{
    [viewFull setHidden:YES];

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
