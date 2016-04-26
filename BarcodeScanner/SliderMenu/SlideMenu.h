//
//  SlideMenu.h
//  Checkk
//
//  Created by admin on 7/15/14.
//  Copyright (c) 2014 Ashwani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SlideMenu : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *tabelview_out;
    BOOL look;
    
}

@property(nonatomic,retain)     IBOutlet UITableView *tabelview_out;


@end
