//
//  MyReportsCell.h
//  BrandReporter
//
//  Created by Gauri Shankar on 01/08/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyReportsCell : UITableViewCell

@property (weak, nonatomic)     IBOutlet UILabel *lblReporter,*lblStatus,*lblProduct;
@property (weak, nonatomic)     IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic)     IBOutlet UIButton *btnHist;
@property (weak, nonatomic)     IBOutlet UIView *viewWhite;

@end
