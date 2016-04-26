//
//  MyReportsVC.m
//  BrandReporter
//
//  Created by Gauri Shankar on 20/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "MyReportsVC.h"
#import "NVSlideMenuController.h"
#import "CreatReportVC.h"
#import "AppDelegate.h"
#import "igViewController.h"
#import "MyReportsCell.h"
#import "MyReportsDetailVC.h"
#import "Constant.h"
#import "DBOperations.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ZViewController.h"

@interface MyReportsVC ()<UISearchDisplayDelegate, UISearchBarDelegate>
{
    UIStoryboard *storyboard;
    IBOutlet UISearchBar *searchBarList;
    AppDelegate *delegate;
    NSMutableArray *arrList;

        NSMutableArray *searchData;
        NSMutableArray *inUseArray;
    

}
@end

@implementation MyReportsVC


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark FOR LEFT MENU ITEM

- (IBAction)backButtonAction:(id)sender
{
    [searchBarList resignFirstResponder];

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



- (IBAction)newButtonAction:(id)sender
{
    delegate.intScanStatus = 2;

    
    storyboard = [AppDelegate storyBoardType];
    
    ZViewController *objVC = (ZViewController*)[storyboard instantiateViewControllerWithIdentifier:@"BarViewControllerId"];
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    delegate.intEditReport = 0;
    [arrList removeAllObjects];
    [inUseArray removeAllObjects];
    
    
    NSLog(@"viewWillAppear arrList %@",arrList);
    
    if([arrList count] ==0)
    {
        [viewLabel setHidden:NO];
        [viewList setHidden:YES];
        
    }
    else
    {
        [viewLabel setHidden:YES];
        [viewList setHidden:NO];
        
        [tblMyReport reloadData];
        
    }
    
    [self getMyReportsList];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    arrList = [[NSMutableArray alloc] init];
    inUseArray = [[NSMutableArray alloc]init];
    searchData = [[NSMutableArray alloc]init];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
    [arrList removeAllObjects];
    
    [inUseArray removeAllObjects];
    
    
    if([arrList count] ==0)
    {
        [viewLabel setHidden:NO];
        [viewList setHidden:YES];
        
    }
    else
    {
        [viewLabel setHidden:YES];
        [viewList setHidden:NO];
        [tblMyReport reloadData];
        
    }
    
    //[tblMyReport setBackgroundColor:[UIColor colorWithRed:64.0/255.0f green:200.0/255.0f blue:214.0/255.0f alpha:1.0]];
    
    
    //[self getMyReportsList];
    
}


#pragma mark API

-(void)getMyReportsList
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading....", nil);
    
    
   NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@",KURLMyReports,[[NSUserDefaults standardUserDefaults] valueForKey:kLoggedInUserId]]];
    
    //NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",KURLMyReports]];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"success: %@", operation.responseString);
         
         [arrList removeAllObjects];
         [inUseArray removeAllObjects];
         
         
         NSString *jsonString = operation.responseString;
         NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
         NSError *jsonError = nil;
         if (JSONdata != nil) {
             
             
             NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:JSONdata options:NSJSONReadingMutableContainers error:&jsonError];
             
             NSLog(@"resDic %@",resDic);
             
             if ([resDic objectForKey:@"result"] ==0)
             {
                 //                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No list found!" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
                 //                     [alert show];
             }
             else
             {
                 
                 NSMutableArray *arrData = [resDic objectForKey:@"response"];
                 arrList = (NSMutableArray*)arrData;
                 inUseArray = (NSMutableArray*)arrData;
                 NSLog(@"inUseArray %@",inUseArray);
                 
                 if([arrList count] ==0)
                 {
                     [viewLabel setHidden:NO];
                     [viewList setHidden:YES];
                     
                 }
                 else
                 {
                     [viewLabel setHidden:YES];
                     [viewList setHidden:NO];
                     
                     [tblMyReport reloadData];
                     
                 }
                 
                 
             }
         }
         else
         {
             //             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No report found!" message:@"Please create " delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
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
    
    return 100;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [inUseArray count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"MyReportsCell";
    
    MyReportsCell *cell1 = (MyReportsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell1 == nil)
    {
        NSArray *nib ;
        
        if (IS_IPHONE_5)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"MyReportsCell" owner:self options:nil];
            
        }
        else if (IS_IPHONE_6)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"MyReportsCell_i6" owner:self options:nil];
            
        }
        else if (IS_IPHONE_6P)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"MyReportsCell_i6P" owner:self options:nil];
            
        }else if (IS_IPHONE_4S)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"MyReportsCell_4S" owner:self options:nil];
            
        }
        cell1 = [nib objectAtIndex:0];
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell1.viewWhite.layer.cornerRadius = 3.0f;
    
    NSDictionary *dictTemp = [inUseArray objectAtIndex:indexPath.row];
        
    cell1.lblProduct.text = [dictTemp valueForKey:@"product"];
    cell1.lblReporter.text = [[NSUserDefaults standardUserDefaults] objectForKey:kLoggedInUserName];
    cell1.lblStatus.text = [dictTemp valueForKey:@"status"];
    
    cell1.imgProduct.layer.cornerRadius = cell1.imgProduct.frame.size.width / 2;
    cell1.imgProduct.clipsToBounds = YES;
    cell1.imgProduct.layer.borderWidth = 2.0f;
    cell1.imgProduct.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    NSArray *arrData = [dictTemp valueForKey:@"report_image"];
    [cell1.imgProduct
     sd_setImageWithURL:[NSURL URLWithString:[arrData objectAtIndex:0]]
     placeholderImage:[UIImage imageNamed:@"TestImg.png"]];
    
    tblMyReport.separatorColor = [UIColor clearColor];
    cell1.btnHist.tag = indexPath.row;
    [cell1.btnHist addTarget:self
                      action:@selector(histAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell1;
}

-(void)histAction:(id)sender
{
    storyboard = [AppDelegate storyBoardType];
    
    MyReportsDetailVC *objVC = (MyReportsDetailVC*)[storyboard instantiateViewControllerWithIdentifier:@"MyReportsDetailVCId"];
    objVC.dictReport = [arrList objectAtIndex:[sender tag]];

    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    storyboard = [AppDelegate storyBoardType];
    
    MyReportsDetailVC *objVC = (MyReportsDetailVC*)[storyboard instantiateViewControllerWithIdentifier:@"MyReportsDetailVCId"];
    objVC.dictReport = [arrList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;

    
}

#pragma mark - Search Bar Delegates

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    // Do the search...
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if ([searchText length] == 0)
    {
        [searchBar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0];
    }
    
    [searchData removeAllObjects];// remove all data that belongs to previous search
    //[inUseArray removeAllObjects];
    
    if([searchText isEqualToString:@""] || searchText==nil)
    {
        NSLog(@"ALL DATA DISPLAY");
        
        inUseArray = arrList;
        
        [searchBar resignFirstResponder];
        [tblMyReport reloadData];
        return;
    }
    
    NSInteger counter = 0;
    
    for(int i=0;i<[arrList count];i++)
    {
        
        //        cell.lblProduct.text = [dictTemp valueForKey:@"product"];
        //        cell.lblReporter.text = [dictTemp valueForKey:@"brand"];
        
        NSLog(@"--  %d",i);
        
        if([[arrList objectAtIndex:i] isEqual:[NSNull null]])
        {
            NSLog(@"No data add");
            
        }
        else
        {
            NSDictionary *dictData = [arrList objectAtIndex:i];
            
            NSString *name = [dictData valueForKey:@"MRProduct"];
            
            if(!name || [name isEqualToString:@""] || [name length]==0)
            {
                NSLog(@"No data");
                NSDictionary *dictData1 = [arrList objectAtIndex:i];
                
                name = [dictData1 valueForKey:@"MRProduct"];
            }
            
            NSRange r = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(r.location != NSNotFound)
            {
                
                NSDictionary *dictData1 = [arrList objectAtIndex:i];
                
                if(![searchData containsObject:dictData1])
                {
                    [searchData addObject:dictData1];
                }
                NSLog(@"dictData--%@",dictData1);
                
            }
            
           
            
            counter++;
        }
    }
    
    inUseArray = searchData.mutableCopy;
    
    if([inUseArray count] >0)
    {
        [tblMyReport reloadData];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    for (UIView *subView in searchBar.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setBackgroundImage:Nil forState:UIControlStateNormal];
            
            [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
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
