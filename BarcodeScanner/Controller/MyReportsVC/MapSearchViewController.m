//
//  MapSearchViewController.m
//
//

#import "MapSearchViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "SnapVC.h"
#import "MyReportsVC.h"
#import "DBOperations.h"
#import "MyReportObject.h"

@interface MapSearchViewController ()<UIAlertViewDelegate>
{
    UIStoryboard *storyboard;
    AppDelegate *appDelegate;
}
@end

@implementation MapSearchViewController
@synthesize manager,mapView,lblSubTitle,lblTitle,txtLoc,viewAnnotation;

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
   
    NSDictionary *userLocation=[[NSUserDefaults standardUserDefaults] objectForKey:@"userLocation"];
    
    NSLog(@"userLocation %@",userLocation);
    
    latitude1=[[userLocation valueForKey:@"lat"] doubleValue];
    longitude1=[[userLocation valueForKey:@"long"] doubleValue];
    
    mapRegion.center.latitude=latitude1 ;
    mapRegion.center.longitude=longitude1 ;
  
    [self.mapView setRegion:mapRegion];
    
    //[self.mapView reloadInputViews];
    
    
    [self getPlace];

    // Do any additional setup after loading the view.
}



#pragma mark - Location Manager Delegate
- (CLLocationManager *)manager {
    
    if (!self.manager) {
        self.manager = [[CLLocationManager alloc]init];
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    }
    return self.manager;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
        NSLog(@"didUpdateToLocation: %@", locations);
    
    _currentLocation = [locations lastObject];
    
    NSNumber *lat = [NSNumber numberWithDouble:_currentLocation.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:_currentLocation.coordinate.longitude];

    NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
    
    [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:@"userLocation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.manager startMonitoringSignificantLocationChanges];
    
    MKCoordinateRegion region;
    if (_currentLocation != nil) {
        region.center.latitude =  _currentLocation.coordinate.latitude;
        region.center.longitude = _currentLocation.coordinate.longitude;
    }
    
    MKCoordinateSpan span;
    span.latitudeDelta=0.0035; // change as per your zoom level
    span.longitudeDelta=0.0035;
    mapRegion.span=span;
    
    [self.mapView setRegion:mapRegion animated:TRUE];
    [self.mapView regionThatFits:mapRegion];

    [self.manager startUpdatingLocation];
    
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
    mapRegion = self.mapView.region;
    [self.mapView setRegion:mapRegion];
    [viewAnnotation setHidden:YES];
    [lblTitle setHidden:YES];
    [lblSubTitle setHidden:YES];

}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [viewAnnotation setHidden:NO];
    [lblTitle setHidden:NO];
    [lblSubTitle setHidden:NO];
    
    MKCoordinateRegion newRegion;
    newRegion = self.mapView.region;
    
//    if( newRegion.span.latitudeDelta>0.025f)
//    {
//        [self.mapView setMapType:MKMapTypeStandard];
//    }
//    else
//    {
        [self.mapView  setMapType:MKMapTypeHybrid];
   // }
    
    newRegion.center.latitude=self.mapView .centerCoordinate.latitude;
    newRegion.center.longitude=self.mapView .centerCoordinate.longitude;
    latitude1=newRegion.center.latitude;
    longitude1=newRegion.center.longitude;
    
    NSLog(@"Position changed");
    NSLog(@"latitude1 %f %f",latitude1,longitude1);

//    if(newRegion.span.longitudeDelta<0.0035)
//    {
//        [self.mapView  setZoomEnabled:NO];
//    }
//    else
//    {
        [self.mapView  setZoomEnabled:YES];
   // }
    
    [self getPlace];
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    if([lblTitle.text length] ==0)
    {
        
        [viewAnnotation setHidden:YES];
        [lblTitle setHidden:YES];
        [lblSubTitle setHidden:YES];
    }
    else
    {
        [viewAnnotation setHidden:NO];
        [lblTitle setHidden:NO];
        [lblSubTitle setHidden:NO];
    }

}


#pragma mark Custom Button Action

-(IBAction)CancelButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)DoneAction:(id)sender
{
    
    [appDelegate.dictRecord setValue:[NSString stringWithFormat:@"%f",latitude1] forKey:@"lat"];
    [appDelegate.dictRecord setValue:[NSString stringWithFormat:@"%f",longitude1] forKey:@"long"];
    
    [appDelegate.dictRecord setValue:lblTitle.text forKey:@"Address"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"eee, dd MMM yyyy"];
    
    NSDate *date1 = [NSDate date];
    
    NSString *formattedDateString = [df stringFromDate:date1];
    
    [appDelegate.dictRecord setValue:formattedDateString forKey:@"Date"];
    [appDelegate.dictRecord setValue:@"Verified" forKey:@"status"];
    
    NSLog(@"submitReport");
    
    [self submitMyReport];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 10)
    {
        
        
        [appDelegate.dictRecord setValue:@"" forKey:@"Date"];
        [appDelegate.dictRecord setValue:@"" forKey:@"long"];
        [appDelegate.dictRecord setValue:@"" forKey:@"lat"];
        [appDelegate.dictRecord setValue:@"" forKey:@"Address"];
        [appDelegate.dictRecord setValue:@"" forKey:@"Comment"];
        [appDelegate.dictRecord setValue:@"" forKey:@"Size"];
        [appDelegate.dictRecord setValue:@"" forKey:@"Product"];
        [appDelegate.dictRecord setValue:@"" forKey:@"Brand"];
        [appDelegate.dictRecord setValue:@"" forKey:@"Manufacture"];
        [appDelegate.dictRecord setValue:@"" forKey:@"Image"];
        [appDelegate.dictRecord setValue:@"" forKey:@"BarCode"];
        
        storyboard = [AppDelegate storyBoardType];
        
        MyReportsVC *objVC = (MyReportsVC*)[storyboard instantiateViewControllerWithIdentifier:@"MyReportsVCId"];
        [self.navigationController pushViewController:objVC animated:YES];
        objVC = nil;
    }
}

#pragma mark Google API

-(void)submitMyReport
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Processing....", nil);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:KURLSubmitReport]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"userid"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[[NSUserDefaults standardUserDefaults] valueForKey:kLoggedInUserId] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    if(appDelegate.intEditReport > 0)
    {
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"productid"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",[NSString stringWithFormat:@"%d",appDelegate.intEditReport]  ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"barcode"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[appDelegate.dictRecord valueForKey:@"BarCode"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"created_date"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[appDelegate.dictRecord valueForKey:@"Date"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"manufacturer"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[appDelegate.dictRecord valueForKey:@"Manufacture"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"brand"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[appDelegate.dictRecord valueForKey:@"Brand"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"product"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[appDelegate.dictRecord valueForKey:@"Product"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"size"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[appDelegate.dictRecord valueForKey:@"Size"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"comments"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[appDelegate.dictRecord valueForKey:@"Comment"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"address"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[appDelegate.dictRecord valueForKey:@"Address"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"geo"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[NSString stringWithFormat:@"%@,%@",[appDelegate.dictRecord valueForKey:@"lat"],[appDelegate.dictRecord valueForKey:@"long"]]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"status"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[NSString stringWithFormat:@"%@",@"Pending"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    
    
    NSArray *arrImg = [appDelegate.dictRecord valueForKey:@"Image"];
    
    for(int i = 0; i<[arrImg count];i++ )
    {
        NSDictionary *dictTemp = [arrImg objectAtIndex:i];
        
        UIImage *imgPic = [dictTemp objectForKey:@"Img"];
        
        NSData *imageData = UIImageJPEGRepresentation(imgPic, 1.0);
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=report_image[%d]; filename=%@\r\n", i,[dictTemp objectForKey:@"Name"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if(data.length > 0)
         {
             //success
             NSLog(@"success");
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             
             NSLog(@"Response: %@", responseString);
             
             if (data != nil) {
                 
                 
                 /* Make something on success */
                 
                 NSData *JSONdata = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                 NSError *jsonError = nil;
                 if (JSONdata != nil)
                 {
                     
                     NSMutableDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                     
                     NSLog(@"resDic %@",resDic);
                     
                     if([[resDic valueForKey:@"result"]intValue] ==0)
                     {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please try again" message:@"Report not submitted!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                         [alert show];
                     }
                     else
                     {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Report submitted!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                         alert.tag=10;
                         [alert show];
                         
                     }
                     
                 }
                 
             } else {
                 
                 /* Make something else if not completed with success */
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Server not reachable. Check internet connectivity" delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
                 [alert show];
                 
                 
             }
             
         }
     }];
}


-(void) getPlace
{
    [viewAnnotation setHidden:NO];
    [lblTitle setHidden:NO];
    [lblSubTitle setHidden:NO];

    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=10&types=&key=%@&sensor=true",
                           latitude1,longitude1,kGooglePlacesAPIBrowserKey];
    
    NSLog(@"home-google urlString %@ %f %f",urlString,latitude1,longitude1);
    
    //build request URL
    NSURL *requestURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //build NSURLRequest
    NSURLRequest *geocodingRequest=[NSURLRequest requestWithURL:requestURL
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:60.0];
    
    //create connection and start downloading data
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:geocodingRequest delegate:self];
    
    if(connection){
        //connection valid, so init data holder
        receivedData = [[NSMutableData alloc] init];
    }else{
        //connection failed, tell delegate
        NSLog(@"connection failed");
        
    }
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{

        // NSLog(@"%@",receivedData);
        [receivedData setLength:0];
  
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
        [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(txtLoc.tag==0)
    {
    NSString *geocodingResponse = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    //result as dictionary dictionary
    NSData *JSONdata = [geocodingResponse dataUsingEncoding:NSUTF8StringEncoding];
    
    if (JSONdata != nil) {
        
        NSError *e;
        NSDictionary *JSON =
        [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: &e];
        
        NSString *status = [JSON valueForKey:@"status"];
        if([status isEqualToString:@"OK"]){
            //if successful
            //get first element as array
            NSMutableArray *arrApi=[[NSMutableArray alloc]init];
           arrApi = [JSON objectForKey:@"results"];
            
            NSLog(@"arr %@",[arrApi objectAtIndex:0]);
            
            NSMutableDictionary *dictTemp=[arrApi objectAtIndex:0];
            lblTitle.text=[dictTemp valueForKey:@"name"];
            lblSubTitle.text=[dictTemp valueForKey:@"vicinity"];
            txtLoc.text=[dictTemp valueForKey:@"name"];
            
            latitude1 = [[[[dictTemp valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] doubleValue];
            longitude1 = [[[[dictTemp valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"] doubleValue];
            
            [appDelegate.dictRecord setValue:[NSString stringWithFormat:@"%@,%@",[[[dictTemp valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"],[[[dictTemp valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"]]  forKey:@"latlong"];

        }
        
                  else{
            //if status code is not OK
            NSError *error = nil;
            
            if([status isEqualToString:@"ZERO_RESULTS"])
            {
                error = [NSError errorWithDomain:@"MJGeocoderError" code:1 userInfo:nil];
            }
            else if([status isEqualToString:@"OVER_QUERY_LIMIT"])
            {
                error = [NSError errorWithDomain:@"MJGeocoderError" code:2 userInfo:nil];
            }
            else if([status isEqualToString:@"REQUEST_DENIED"])
            {
                error = [NSError errorWithDomain:@"MJGeocoderError" code:3 userInfo:nil];
            }
            else if([status isEqualToString:@"INVALID_REQUEST"])
            {
                error = [NSError errorWithDomain:@"MJGeocoderError" code:4 userInfo:nil];
            }
            
        }
    }
    
    }
    else
    {
        txtLoc.tag=0;
    }
}

#pragma mark TextField Delegate

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text=@"";
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [txtLoc resignFirstResponder];
    NSLog(@"search Text %@",textField.text);
    txtLoc.tag=1;

    [self getSearchResults:textField.text];
    return YES;
}

-(void) getSearchResults:(NSString *)searchText
{
    NSString* encodedString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?location=%f,%f&types=establishment|locality|country|cafe|food|bar|park|route&radius=50000&query=%@&key=%@",_currentLocation.coordinate.latitude,_currentLocation.coordinate.longitude,searchText,kGooglePlacesAPIBrowserKey];
    NSString *reqPath=[encodedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"url:%@",reqPath);

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:reqPath parameters:@{                                                                                                                                 @"searchdata":searchText}
                                                                             constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    
                                    {
                                        
                                        
                                        
                                    } error:nil];
    
    [request setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [self parseUserProfileResponse:[operation responseString]];
        NSError *e;
        NSDictionary *JSON =
        [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                        options: NSJSONReadingMutableContainers
                                          error: &e];
        NSLog(@"%@",JSON);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

- (void)parseUserProfileResponse:(NSString *)responseString
{
    
    NSData *JSONdata = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError = nil;
    
    if (JSONdata != nil) {
        NSMutableDictionary *resDic = [NSJSONSerialization
                                       JSONObjectWithData:JSONdata
                                       options:NSJSONReadingMutableContainers error:&jsonError];
        if ([resDic count])
        {
            NSMutableArray *array=[[NSMutableArray alloc]init];
            NSMutableArray *arrGeometry=[[NSMutableArray alloc]init];
            NSMutableArray *arrLocation=[[NSMutableArray alloc]init];
            array = [resDic valueForKey:@"results"];
            if(array.count>0)
            {
            NSMutableDictionary *dictTemp=[array objectAtIndex:0];
            lblTitle.text=[dictTemp valueForKey:@"name"];
            lblSubTitle.text=[dictTemp valueForKey:@"formatted_address"];
            for (int idx = 0; idx<[array count];idx++) {
                NSMutableDictionary *dict=[array objectAtIndex:idx];
                [dict setObject:[NSString stringWithFormat:@"%d",idx]  forKey:@"check1"];
                [arrGeometry addObject:[dict objectForKey:@"geometry"]];
                
                
            }
            
            for(int i=0;i<arrGeometry.count;i++)
            {
                NSMutableDictionary *dictLocation=[arrGeometry objectAtIndex:i];
                
                [arrLocation addObject:[dictLocation objectForKey:@"location"]];
            }

                
                NSMutableDictionary *dicLatLong=[arrLocation objectAtIndex:0];
                
                latitude1 = [dicLatLong[@"lat"] doubleValue];
                longitude1 = [dicLatLong[@"lng"] doubleValue];
            
            mapRegion.center.latitude=latitude1 ;
            mapRegion.center.longitude=longitude1 ;
            mapRegion.span.latitudeDelta=0.0035; // change as per your zoom level
            mapRegion.span.longitudeDelta=0.0035;
            [self.mapView setRegion:mapRegion];

           
       
        }else{
            NSLog(@"Error-Log: %@", jsonError);
        }
    }else{
        // Log reason for error.
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
