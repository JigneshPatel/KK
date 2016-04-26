//
//  GiftBroucherTableViewCell.h
//  Kalara
//
//  Created by Gauri Shankar on 28/10/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftBroucherTableViewCell : UITableViewCell

@property (weak, nonatomic)     IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic)     IBOutlet UILabel *lblTitle,*lblDsc,*lblOld,*lblNew;

@end
