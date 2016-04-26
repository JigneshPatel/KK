//
//  AppDelegate.h
//  Kalara
//
//  Created by Gauri Shankar on 16/09/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideMenu.h"
#import "NVSlideMenuController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    UINavigationController *navController;
    int intEditReport,intScanStatus;
    NSMutableDictionary *dictRecord;
}

@property (strong, nonatomic) NSMutableDictionary *dictRecord;
@property (strong, nonatomic)NSMutableString *AD_noti_tid;


@property (strong, nonatomic) UIWindow *window;
@property int intEditReport,intScanStatus;
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *cLocation;

+ (AppDelegate *)sharedAppDelegate;
+ (UIStoryboard *)storyBoardType;
+ (UIImage*)getImage:(NSString *)strImageName fromFolder:(NSString *)strFolderName;

@end

