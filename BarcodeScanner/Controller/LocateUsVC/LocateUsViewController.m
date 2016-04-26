//
//  LocateUsViewController.m
//  Kalara
//
//  Created by Gauri Shankar on 25/10/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "LocateUsViewController.h"
#import "NVSlideMenuController.h"
#import "MyAccountVC.h"
#import "HotAlertsVC.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import <MapKit/MapKit.h>


@interface LocateUsViewController ()<MKMapViewDelegate>
{
    AppDelegate *appDelegate;
    UIStoryboard *storyboard;
    IBOutlet MKMapView *mapview;
    NSMutableArray *arrAnnotation;
}
@end

@implementation LocateUsViewController

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

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
    
    arrAnnotation = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    [self getMyReportsList];
    
    [mapview setDelegate:self];


}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    
    if ( (region.center.latitude >= -90) && (region.center.latitude <= 90) && (region.center.longitude >= -180) && (region.center.longitude <= 180))
    {
        [mapview setRegion:[mapview regionThatFits:region] animated:YES];
    }
    
    
}


#pragma mark API integration

-(void)addAnnotation
{
    
    for(int i =0;i<[arrAnnotation count];i++)
    {
        MKPointAnnotation *ann = [[MKPointAnnotation alloc]init];
        ann.title=[[arrAnnotation objectAtIndex:i] valueForKey:@"location"];
        ann.subtitle = [[arrAnnotation objectAtIndex:i] valueForKey:@"address"];
        
        ann.coordinate = CLLocationCoordinate2DMake([[[arrAnnotation objectAtIndex:i] valueForKey:@"latitude"] floatValue], [[[arrAnnotation objectAtIndex:i] valueForKey:@"longitude"] floatValue]);
        [mapview addAnnotation:ann];
        ann=nil;
    }
    
}


#pragma mark -
#pragma mark MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //
    
    static NSString* AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapview dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    //if(annotation != mapView.userLocation) {
        
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        
        customPinView.image = [UIImage imageNamed:@"Pin.png"];
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        
        //
        // Initialize the MKPinAnnotationView...
        //logo = "http:/food.vervetelecom.com/uploads/1431161950.jpg";
        
        NSLog(@"view.annotation %@",annotation.title);
        
    
        
        
        //
        return customPinView;
        
//    }
//    else {
//        
//        pinView.annotation = annotation;
//        return pinView;
//        
//    }
    
}

#pragma mark API

-(void)getMyReportsList
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading....", nil);
    
    
    NSURL *url = [[NSURL alloc] initWithString:KURLGetLocation];
    
    
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
                 //                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No list found!" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
                 //                     [alert show];
             }
             else
             {
                 
                 arrAnnotation = [resDic objectForKey:@"response"];
                 
                 NSLog(@"inUseArray %@",arrAnnotation);
                 
                 [self addAnnotation];

                
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
