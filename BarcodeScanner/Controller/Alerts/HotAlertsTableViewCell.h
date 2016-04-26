//
//  HotAlertsTableViewCell.h
//  BrandReporter
//
//  Created by Brahmasys on 23/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotAlertsTableViewCell : UITableViewCell

@property (weak, nonatomic)     IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic)     IBOutlet UIButton *btnShare;
@property (weak, nonatomic)     IBOutlet UILabel *lblTitle;
@property (weak, nonatomic)     IBOutlet UITextView *lblSubTitle;
@end
