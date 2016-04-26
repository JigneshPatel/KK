//
//  MapDetailVC.m
//  BrandReporter
//
//  Created by Gauri Shankar on 08/08/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "MapDetailVC.h"
#import <MapKit/MapKit.h>
#import "MapPinAnnotation.h"

@interface MapDetailVC ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet MKMapView *mapview;
    NSString *strLat,*strLong;
    
}

@property (strong, nonatomic) CLLocationManager *manager;

-(IBAction)backButton:(id)sender;

@end

@implementation MapDetailVC

@synthesize strLatLong;


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // in your program you will likely need to use custom annotation objects
    
    if([strLatLong length]>0)
    {
        
    
    NSArray *myWords = [strLatLong componentsSeparatedByString:@","];
    
    NSLog(@"strLatLong %@ myWords %@",strLatLong,myWords);

    strLat = [myWords objectAtIndex:0];
    strLong = [myWords objectAtIndex:1];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[myWords objectAtIndex:0] doubleValue],
                                                                   [[myWords objectAtIndex:1] doubleValue]);
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.00;
    span.longitudeDelta = 0.00;
    
    //region.span = span;
    region.center = coordinate;
    
    [mapview setRegion:region animated:YES];
    [mapview regionThatFits:region];
    
    [self addAnnotation];
    }
    else
    {
        mapview.showsUserLocation=YES;
    }
    
}

#pragma mark - Location Manager Delegate
- (CLLocationManager *)manager {
    
    if (!self.manager) {
        self.manager = [[CLLocationManager alloc]init];
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        //[_manager startMonitoringSignificantLocationChanges];
        
    }
    return self.manager;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
                
            case kCLAuthorizationStatusDenied:
            {
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"App level settings has been denied" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.tag = 11;
                
                [alert show];
                alert= nil;
            }
                break;
            case kCLAuthorizationStatusNotDetermined:
            {
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The user is yet to provide the permission" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                alert= nil;
            }
                break;
            case kCLAuthorizationStatusRestricted:
            {
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The app is recstricted from using location services." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                alert= nil;
            }
                break;
                
            default:
                break;
        }
    }
    else{
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Error" message:@"The location services seems to be disabled from the settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        alert= nil;
    }
}

#pragma mark API integration

-(void)addAnnotation
{
    
    
    MKPointAnnotation *ann = [[MKPointAnnotation alloc]init];
    ann.coordinate = CLLocationCoordinate2DMake([strLat floatValue], [strLong floatValue]);
    [mapview addAnnotation:ann];
    ann=nil;
    
    
}

#pragma mark -
#pragma mark MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //
    
    static NSString* AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapview dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if(annotation != mapView.userLocation) {
        
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        
        customPinView.image = [UIImage imageNamed:@"mappin@2x.png"];
        customPinView.animatesDrop = NO;
        customPinView.canShowCallout = YES;
        customPinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return customPinView;
        
    }
    else {
        
        pinView.annotation = annotation;
        return pinView;
        
    }
    
}

#pragma mark Custom Button Action

-(IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
