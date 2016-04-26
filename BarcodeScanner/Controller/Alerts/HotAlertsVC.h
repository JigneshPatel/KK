//
//  HotAlertsVC.h
//  BrandReporter
//
//  Created by Brahmasys on 21/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotAlertsVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL look;
    IBOutlet UITableView *tblList;
    NSMutableArray *arrList;
}

@property(strong,nonatomic) NSMutableArray *arrList;


@end
