//
//  KnowledgeVC.m
//  BrandReporter
//
//  Created by Brahmasys on 21/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "KnowledgeVC.h"
#import "NVSlideMenuController.h"
#import "KnowledgeTableViewCell.h"
#import "CreatReportVC.h"
#import "AppDelegate.h"
#import "KnowledgeDetailVC.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface KnowledgeVC ()<UISearchDisplayDelegate, UISearchBarDelegate>
{
    UIStoryboard *storyboard;
    IBOutlet UISearchBar *searchBarList;
    NSMutableArray *searchData;
    NSMutableArray *inUseArray;
    
}
@end

@implementation KnowledgeVC

@synthesize arrList,tblList;

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark FOR LEFT MENU ITEM

- (IBAction)backButtonAction:(id)sender {
    
    if (!look)
    {
        [searchBarList resignFirstResponder];
        
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
    [self.navigationController setNavigationBarHidden:YES];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [tblList setBackgroundColor:[UIColor colorWithRed:64.0/255.0f green:200.0/255.0f blue:214.0/255.0f alpha:1.0]];

    arrList = [[NSMutableArray alloc] init];
    inUseArray = [[NSMutableArray alloc]init];
    searchData = [[NSMutableArray alloc]init];

    /*
    NSDictionary *dictData = @{@"barcode" : @"1234567", @"manufacture" : @"Pillitteri",@"brand" : @"Ice Wine", @"product" : @"Ice Wine's Merlot", @"size" : @"6X700ml",@"Comment" : @"No Comments Available",@"image" : @"Ice Wine.png"};
    [arrList addObject:dictData];
    [inUseArray addObject:dictData];

    dictData = @{@"barcode" : @"1245765987987", @"manufacture" : @"Beats",@"brand" : @"Beats by Dre", @"product" : @"Head Phones", @"size" : @"Large",@"Comment" : @"No Comments Available",@"image" : @"Beats by Dre.png"};
    [arrList addObject:dictData];
    [inUseArray addObject:dictData];

    dictData = @{@"barcode" : @"12685387608760875", @"manufacture" : @"Decker ",@"brand" : @"Ugg Ultra", @"product" : @"Low Cut Ugg Shoes", @"size" : @"Any",@"Comment" : @"No Comments Available",@"image" : @"Decker.png"};
    [arrList addObject:dictData];
    [inUseArray addObject:dictData];

    dictData = @{@"barcode" : @"NA", @"manufacture" : @"US Government",@"brand" : @"Currency", @"product" : @"$100 Note", @"size" : @"$100 Note",@"Comment" : @"No Comments Available",@"image" : @"US Government.png"};
    [arrList addObject:dictData];
    [inUseArray addObject:dictData];

    dictData = @{@"barcode" : @"NA", @"manufacture" : @"Nike",@"brand" : @"Air Jordan", @"product" : @"Jordan IVs", @"size" : @"NA",@"Comment" : @"No Comments Available",@"image" : @"nike Air Jordan.png"};
    [arrList addObject:dictData];
    [inUseArray addObject:dictData];

    dictData = @{@"barcode" : @"NA", @"manufacture" : @"Oakley Inc",@"brand" : @"Oakley", @"product" : @"Oakley Sunglasses", @"size" : @"NA",@"Comment" : @"No Comments Available",@"image" : @"Oakley Sunglasses.png"};
    [arrList addObject:dictData];
    [inUseArray addObject:dictData];
    
    
    
    [tblList reloadData];
     */
    
    [self getKnowledgeLibrary];
}

#pragma mark API

-(void)getKnowledgeLibrary
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
         
         [arrList removeAllObjects];
         [inUseArray removeAllObjects];
         
         NSString *jsonString = operation.responseString;
         NSData *JSONdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
         
         NSError *jsonError = nil;
         if (JSONdata != nil) {
             
             NSArray *arrTemp = [NSJSONSerialization JSONObjectWithData:JSONdata options:NSJSONReadingMutableContainers error:&jsonError];
             
//             arrList = [NSJSONSerialization JSONObjectWithData:JSONdata options:NSJSONReadingMutableContainers error:&jsonError];
//             inUseArray= [NSJSONSerialization JSONObjectWithData:JSONdata options:NSJSONReadingMutableContainers error:&jsonError];
             
             NSLog(@"arrTemp %@",arrTemp);
            
             for(int i=0;i<[arrTemp count];i++)
             {
                 NSMutableDictionary *dictTemp = [arrTemp objectAtIndex:i];
                 
                 if([dictTemp[@"barcode"] isKindOfClass:[NSNull class]])
                 {
                     [dictTemp setObject:@"" forKey:@"barcode"];
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
                 [arrList addObject:dictTemp];
                 [inUseArray addObject:dictTemp];
             }
            
             [tblList reloadData];
        
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

#pragma mark Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 130;
    
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
    
    static NSString *simpleTableIdentifier = @"UserCell";
    
    KnowledgeTableViewCell *cell = (KnowledgeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        
        if (IS_IPHONE_5)
        {
             nib = [[NSBundle mainBundle] loadNibNamed:@"KnowledgeTableViewCell" owner:self options:nil];
            
        }
        else if (IS_IPHONE_6)
        {
             nib = [[NSBundle mainBundle] loadNibNamed:@"KnowledgeTableViewCell_i6" owner:self options:nil];
            
        }
        else if (IS_IPHONE_6P)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"KnowledgeTableViewCell_i6P" owner:self options:nil];
            
        }
        else if (IS_IPHONE_4S)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"KnowledgeTableViewCell_4S" owner:self options:nil];
            
        }

        cell = [nib objectAtIndex:0];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.viewWhite.layer.cornerRadius = 3.0f;

    NSDictionary *dictTemp = [inUseArray objectAtIndex:indexPath.row];
    
    if([dictTemp[@"barcode"] isKindOfClass:[NSNull class]])
    {
        cell.lblBarCode.text = @"";
    }
    else
    {
        cell.lblBarCode.text = dictTemp[@"barcode"];
    }
    if([dictTemp[@"manufacture"] isKindOfClass:[NSNull class]])
    {
        cell.lblManu.text = @"";
    }
    else
    {
        cell.lblManu.text = dictTemp[@"manufacture"];
    }
    if([dictTemp[@"brand"] isKindOfClass:[NSNull class]])
    {
        cell.lblBrand.text = @"";
    }
    else
    {
        cell.lblBrand.text = dictTemp[@"brand"];
    }
    if([dictTemp[@"product"] isKindOfClass:[NSNull class]])
    {
        cell.lblProduct.text = @"";
    }
    else
    {
        cell.lblProduct.text = dictTemp[@"product"];
    }
    if([dictTemp[@"size"] isKindOfClass:[NSNull class]])
    {
        cell.lblSize.text = @"";
    }
    else
    {
        cell.lblSize.text = dictTemp[@"size"];
    }
    
    cell.imgProduct.layer.cornerRadius = cell.imgProduct.frame.size.width / 2;
    cell.imgProduct.clipsToBounds = YES;
    
    cell.layer.cornerRadius = 2.0f;
    
    NSString *strImg = dictTemp[@"thumbnail"];
    
    [cell.imgProduct
     sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KBaseUrl,strImg]]
     placeholderImage:[UIImage imageNamed:@"TestImg.png"]];

    tblList.separatorColor = [UIColor clearColor];

    cell.btnHist.tag = indexPath.row;
    
    [cell.btnHist addTarget:self
                     action:@selector(histAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)histAction:(id)sender
{
    storyboard = [AppDelegate storyBoardType];
    KnowledgeDetailVC *objVC = (KnowledgeDetailVC*)[storyboard instantiateViewControllerWithIdentifier:@"KnowledgeDetailVCId"];
    objVC.dictData = [inUseArray objectAtIndex:[sender tag]];

    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    storyboard = [AppDelegate storyBoardType];
    KnowledgeDetailVC *objVC = (KnowledgeDetailVC*)[storyboard instantiateViewControllerWithIdentifier:@"KnowledgeDetailVCId"];
    objVC.dictData = [inUseArray objectAtIndex:indexPath.row];

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
    
    if([searchText isEqualToString:@""] || searchText==nil)
    {
        NSLog(@"ALL DATA DISPLAY");
        
        inUseArray = arrList;
        
        [searchBar resignFirstResponder];
        [tblList reloadData];
        return;
    }
    
    NSInteger counter = 0;
    
    for(int i=0;i<[arrList count];i++)
    {
        
        if([[arrList objectAtIndex:i] isEqual:[NSNull null]])
        {
            NSLog(@"No data add");
        }
        else
        {
            NSDictionary *dictData = [arrList objectAtIndex:i];
            
            NSString *name = [dictData valueForKey:@"brand"];
            
            if(!name || [name isEqualToString:@""] || [name length]==0)
            {
                NSLog(@"No data");
                NSDictionary *dictData1 = [arrList objectAtIndex:i];
                
                name = [dictData1 valueForKey:@"brand"];
            }
            
            NSRange r = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(r.location != NSNotFound)
            {
                
                NSDictionary *dictData1 = [arrList objectAtIndex:i];
                
                [searchData addObject:dictData1];
            }
            
            //barcode
            NSString *barcode = [dictData valueForKey:@"barcode"];
            
            if(!barcode || [barcode isEqualToString:@""] || [barcode length]==0)
            {
                NSLog(@"No data");
                NSDictionary *dictData1 = [arrList objectAtIndex:i];
                
                barcode = [dictData1 valueForKey:@"barcode"];
            }
            
            NSRange rbarcode = [barcode rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(rbarcode.location != NSNotFound)
            {
                
                NSDictionary *dictData1 = [arrList objectAtIndex:i];
                
                if(![searchData containsObject:dictData1])
                {
                    [searchData addObject:dictData1];
                }
                
            }

            NSString *manufacture = [dictData valueForKey:@"manufacture"];
            
            if(!manufacture || [manufacture isEqualToString:@""] || [manufacture length]==0)
            {
                NSDictionary *dictData1 = [arrList objectAtIndex:i];
                
                manufacture = [dictData1 valueForKey:@"manufacture"];
            }
            
            NSRange rmanufacture = [manufacture rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(rmanufacture.location != NSNotFound)
            {
                
                NSDictionary *dictData1 = [arrList objectAtIndex:i];
                
                if(![searchData containsObject:dictData1])
                {
                    [searchData addObject:dictData1];
                }
                
            }
            
            NSString *product = [dictData valueForKey:@"product"];
            
            if(!product || [product isEqualToString:@""] || [product length]==0)
            {
                NSDictionary *dictData1 = [arrList objectAtIndex:i];
                
                product = [dictData1 valueForKey:@"product"];
            }
            
            NSRange rproduct = [product rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(rproduct.location != NSNotFound)
            {
                
                NSDictionary *dictData1 = [arrList objectAtIndex:i];
                
                if(![searchData containsObject:dictData1])
                {
                    [searchData addObject:dictData1];
                }
                
            }
            
            NSString *size = [dictData valueForKey:@"size"];
            
            if(!size || [size isEqualToString:@""] || [size length]==0)
            {
                NSDictionary *dictData1 = [arrList objectAtIndex:i];
                
                size = [dictData1 valueForKey:@"size"];
            }
            
            NSRange rsize = [size rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(rsize.location != NSNotFound)
            {
                
                NSDictionary *dictData1 = [arrList objectAtIndex:i];
                
                if(![searchData containsObject:dictData1])
                {
                    [searchData addObject:dictData1];
                }
                
            }

            
            counter++;
        }
    }
    
    inUseArray = searchData.mutableCopy;
    
    if([inUseArray count] >0)
    {
        [tblList reloadData];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    for (UIView *subView in searchBar.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
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
