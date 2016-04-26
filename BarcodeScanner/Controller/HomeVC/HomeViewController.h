//
//  HomeViewController.h
//  Kalara
//
//  Created by Gauri Shankar on 24/10/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
{
    BOOL look;
    NSMutableDictionary *dictInfo;

}

@property (strong, nonatomic) NSMutableDictionary *dictInfo;

- (IBAction)backButtonAction:(id)sender;

@end
