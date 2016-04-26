//
//  Constant.h
//  Kalara
//
//  Created by Gauri Shankar on 17/09/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#ifndef Kalara_Constant_h
#define Kalara_Constant_h

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4S (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kGooglePlacesAPIBrowserKey @"AIzaSyAdIoz7SMgZ1ovpHyvGMOXfbTUz96h5fuI"

#define KFBId @"441420726062879"

#define KBaseUrl @"http://brandreporter.co/"

#define KURLGetLocation @"http://www.support-4-pc.com/clients/kalara/admin/sub.php?action=getlocation"

#define KURLHotAlerts @"http://www.support-4-pc.com/clients/kalara/subscriber.php?action=getnotification"

#define KURLKnowledgeLib  @"http://brandreporter.co/webservice/new_webservice.php?action=knowladge_library"

#define KURLDiscoverProduct  @"http://www.support-4-pc.com/clients/kalara/subscriber.php?action=getproduct"

#define KURLEditProfile  @"http://www.support-4-pc.com/clients/kalara/subscriber.php?action=editpro"

#define KURLProfile  @"http://www.support-4-pc.com/clients/kalara/subscriber.php?action=profile"

//#define KURLSignUp  @"www.support-4-pc.com/clients/kalara/subscriber.php?action=register"

#define KURLSignUp  @"http://www.support-4-pc.com/clients/kalara/admin/sub.php?action=register"

#define KURLHome @"http://www.support-4-pc.com/clients/kalara/subscriber.php?action=getoffer"

#define KURLForgotPwd  @"http://www.support-4-pc.com/clients/kalara/subscriber.php?action=forgotpass"

#define KURLSignIn  @"http://www.support-4-pc.com/clients/kalara/subscriber.php?action=login"

#define KURLSubmitReport  @"http://www.support-4-pc.com/clients/kalara/subscriber.php?action=submit_report"


#define KURLMyReports  @"http://www.support-4-pc.com/clients/kalara/admin/sub.php?action=getreport1&userid="

#define KURLDeleteReport  @"http://www.support-4-pc.com/clients/kalara/subscriber.php?action=delreport&id="



#define kLoggedInUserId @"LoggedInUserId"
#define kLoggedInUserPwd @"LoggedInUserPwd"
#define kLoggedInUserName @"LoggedInUserName"
#define kLoggedInUserEmail @"LoggedInUserEmail"
#define kLoggedInUserImage @"LoggedInUserImage"
#define kLoggedInUserDOB @"LoggedInUserDOB"

#endif
