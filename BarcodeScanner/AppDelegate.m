//
//  AppDelegate.m
//  Kalara
//
//  Created by Gauri Shankar on 16/09/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "AppDelegate.h"
#import "Constant.h"
#import "DBOperations.h"
#import "ProductDetailVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize intEditReport,dictRecord,intScanStatus;


DBOperations *dbOperationsObject;
NSArray *paths;


+ (UIImage*)getImage:(NSString *)strImageName fromFolder:(NSString *)strFolderName
{
    NSString *documentDirectory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imagePath=[documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",strImageName]];
    UIImage *image=[UIImage imageWithContentsOfFile:imagePath];
    return image;
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (UIStoryboard *)storyBoardType
{
    UIStoryboard *storyboard;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        //storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone5" bundle:nil];
        
        ///*
        if (IS_IPHONE_5)
        {   // iPhone 6 and iPhone 6+
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone5
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone5" bundle:nil];
            
            NSLog(@"loaded iPhone5 Storyboard");
        }
        else if (IS_IPHONE_4S)
        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            NSLog(@"loaded iPhone4 Storyboard");
        }
        else if (IS_IPHONE_6)
        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone6" bundle:nil];
            
            NSLog(@"loaded Main_iPhone6 Storyboard");
        }
        else if (IS_IPHONE_6P)
        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone6P" bundle:nil];
            
            NSLog(@"loaded Main_iPhone6P Storyboard");
        }
        
        // */
        
        
    }
    
    
    return storyboard;
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    
    if([sourceApplication isEqual:@"com.apple.mobilesafari"])
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation
                ];
    }
    else
    {
        SlideMenu *menuVC = [[SlideMenu alloc] init];
        UINavigationController *menuNavigationController = [[UINavigationController alloc] initWithRootViewController:menuVC];
        
        UIStoryboard *storyboard = [AppDelegate storyBoardType];
        
        ProductDetailVC *viewController = (ProductDetailVC*)[storyboard instantiateViewControllerWithIdentifier:@"ProductDetailVCId"];
        
        UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        NVSlideMenuController *slideMenuVC = [[NVSlideMenuController alloc] initWithMenuViewController:menuNavigationController andContentViewController:navController1];
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.window setBackgroundColor:[UIColor yellowColor]];
        
        self.window.rootViewController = slideMenuVC;
        
        return YES;
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    intScanStatus = 0;
    self.AD_noti_tid=[[NSMutableString alloc]init];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications]; // you can also set here for local notification.
    } else {
        
    }
    
    // Override point for customization after application launch.
    dictRecord = [[NSMutableDictionary alloc] init];
    [self DBCreation];
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    
    
    if ([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.manager requestAlwaysAuthorization];
    }
    
    [self.manager startUpdatingLocation];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    SlideMenu *menuVC = [[SlideMenu alloc] init];
    UINavigationController *menuNavigationController = [[UINavigationController alloc] initWithRootViewController:menuVC];
    
    UIViewController *viewController;
    
    //    if([[[NSUserDefaults standardUserDefaults] valueForKey:kLoggedInUserId] length]>0)
    //    {
    //        NSLog(@"Already logged in");
    //        viewController =[[AppDelegate storyBoardType] instantiateViewControllerWithIdentifier:@"MyReportsVCId"];
    //
    //    }
    //    else
    //    {
    NSLog(@"Start logged in");
    viewController =[[AppDelegate storyBoardType] instantiateViewControllerWithIdentifier:@"MainHomeViewControllerId"];
    
    
    //}
    
    
    
    UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    NVSlideMenuController *slideMenuVC = [[NVSlideMenuController alloc] initWithMenuViewController:menuNavigationController andContentViewController:navController1];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.window setBackgroundColor:[UIColor yellowColor]];
    
    self.window.rootViewController = slideMenuVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark-
#pragma mark DB Creation

-(void)DBCreation
{
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"paths Appdelegate %@",paths);
    dbOperationsObject = [DBOperations dbOperationsObject];
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
            break;
        default:{
            [self.manager startUpdatingLocation];
        }
            break;
    }
}


- (CLLocationManager *)manager {
    
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        
        //set the amount of metres travelled before location update is made
    }
    return _manager;
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    _cLocation = [locations lastObject];
    
    NSNumber *lat = [NSNumber numberWithDouble:_cLocation.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:_cLocation.coordinate.longitude];
    
    NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
    
    [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:@"userLocation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.manager startUpdatingLocation];
    
}


#pragma mark PUSH NOTIFICATION
#pragma mark -

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
{
    
    NSString *deviceToken = [[[[token description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"device token = %@", deviceToken);
    
    [self.AD_noti_tid setString:deviceToken];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"PN REG Failed" message:err.description delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    alertView.tag = 11;
    [alertView show];
    
    NSString *str1 = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str1);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    application.applicationIconBadgeNumber = 0;
    
    for (id key in userInfo)
    {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    
    NSLog(@"remote notification: %@",[userInfo description]);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    NSString *alert = [apsInfo objectForKey:@"alert"];
    NSLog(@"Received Push Alert: %@", alert);
    
    NSString *sound = [apsInfo objectForKey:@"sound"];
    NSLog(@"Received Push Sound: %@", sound);
    
    NSString *badge = [apsInfo objectForKey:@"badge"];
    NSLog(@"Received Push Badge: %@", badge);
    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    
    if (application.applicationState == UIApplicationStateActive)
    {
        NSLog(@"App running");
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Notification" message:alert delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"View",nil];
        alertView.tag = 11;
        [alertView show];
    }
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
