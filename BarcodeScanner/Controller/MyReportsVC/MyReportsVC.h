//
//  MyReportsVC.h
//  BrandReporter
//
//  Created by Gauri Shankar on 20/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyReportsVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL look;
    IBOutlet UITableView *tblMyReport;
    IBOutlet UIView *viewLabel,*viewList;
}

- (IBAction)backButtonAction:(id)sender;
- (IBAction)newButtonAction:(id)sender;

@end
