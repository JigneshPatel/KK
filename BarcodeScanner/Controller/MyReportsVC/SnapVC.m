//
//  SnapVC.m
//  BrandReporter
//
//  Created by Gauri Shankar on 01/08/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "SnapVC.h"
#import "NVSlideMenuController.h"
#import "CreatReportVC.h"
#import "AppDelegate.h"
#import "MyCell.h"
#import "DBOperations.h"

@interface SnapVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIStoryboard *storyboard;
    AppDelegate *delegate;
    IBOutlet UIImageView *imgReport;
    UIImagePickerController *profile_ImagePicker;
    IBOutlet UICollectionView *collView;
    NSMutableArray *arrPost;
    int intRow;
}

-(IBAction)galleryAction:(id)sender;
-(IBAction)cameraAction:(id)sender;

@end

@implementation SnapVC

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

- (void)viewDidLoad
{
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    profile_ImagePicker = [[UIImagePickerController alloc]init];
    arrPost = [[NSMutableArray alloc] init];
    
    [collView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellWithReuseIdentifier:@"CELL"];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if(delegate.intEditReport > 0)
    {
        NSArray *arrImg = [delegate.dictRecord valueForKey:@"image"];
        
        for(int i = 0;i<[arrImg count];i++)
        {
            UIImage *newImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[arrImg objectAtIndex:i]]]];
            
            int timestamp = [[NSDate date] timeIntervalSince1970];
            NSString *time=[NSString stringWithFormat:@"%d",timestamp];
            
            NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
            [dictTemp setObject:newImage forKey:@"Img"];
            [dictTemp setObject:[NSString stringWithFormat:@"%@.png",time] forKey:@"Name"];
            
            [arrPost addObject:dictTemp];
        }
        
        [collView reloadData];
        
    }
    
}

- (IBAction)newButtonAction:(id)sender
{
    /*
    if([arrPost count] == 0)
    {
        //        [arrPost addObject:[UIImage imageNamed:@"TestImg.png"]];
        //        [delegate.dictRecord setValue:arrPost forKey:@"Image"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select image for product" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
        */
    
    if([arrPost count] > 5)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Maximum five product image will be used!" message:@"Please remove extra image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
  
    }
    else
    {
        
        [delegate.dictRecord setValue:arrPost forKey:@"Image"];
        
        NSLog(@"%@",delegate.dictRecord);
        
        storyboard = [AppDelegate storyBoardType];
        CreatReportVC  *objVC = (CreatReportVC*)[storyboard instantiateViewControllerWithIdentifier:@"CreatReportVCId"];
        
        [self.navigationController pushViewController:objVC animated:YES];
        objVC = nil;
    }
    
    
}

-(IBAction)galleryAction:(id)sender
{
    profile_ImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    profile_ImagePicker.delegate = (id)self;
    profile_ImagePicker.editing = YES;

    [self presentViewController:profile_ImagePicker animated:YES completion:nil];

}

-(IBAction)cameraAction:(id)sender
{

    profile_ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//UIImagePickerControllerSourceTypePhotoLibrary;//
    profile_ImagePicker.editing = YES;
    profile_ImagePicker.delegate = (id)self;
    
    [self presentViewController:profile_ImagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    UIGraphicsBeginImageContext(CGSizeMake(400,400));
    [image drawInRect:CGRectMake(0,0,400,400)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imgReport setImage:newImage];
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *time=[NSString stringWithFormat:@"%d",timestamp];
    
    NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] init];
    [dictTemp setObject:newImage forKey:@"Img"];
    [dictTemp setObject:[NSString stringWithFormat:@"%@.png",time] forKey:@"Name"];

    [arrPost addObject:dictTemp];
    [collView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}


#pragma mark Collectinview Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        return CGSizeMake(158, 158);
    
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
   
   
    return arrPost.count;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
 
    NSDictionary *dictTemp = [arrPost objectAtIndex:indexPath.row];
    
    cell.imgView.image = [dictTemp objectForKey:@"Img"];
    cell.btnCross.tag = indexPath.row;
    [cell.btnCross addTarget:self action:@selector(crossButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    return cell;

}

-(void)crossButtonAction:(id)sender
{
    NSLog(@"crossButtonAction %ld",(long)[sender tag]);
    intRow = (int)[sender tag];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you really want to delete" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO", nil];
    alert.tag = 11;
    [alert show];
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath %ld",(long)indexPath.row);
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 11)
    {
    if (buttonIndex ==0)
    {
        
        [arrPost removeObjectAtIndex:intRow];
        [collView reloadData];
        
    }
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
