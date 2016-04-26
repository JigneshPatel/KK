//
//  KnowledgeTableViewCell.h
//  BrandReporter
//
//  Created by Brahmasys on 23/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KnowledgeTableViewCell : UITableViewCell

@property (weak, nonatomic)     IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic)     IBOutlet UIButton *btnHist;
@property (weak, nonatomic)     IBOutlet UILabel *lblBarCode;
@property (weak, nonatomic)     IBOutlet UILabel *lblManu;
@property (weak, nonatomic)     IBOutlet UILabel *lblBrand;
@property (weak, nonatomic)     IBOutlet UILabel *lblProduct;
@property (weak, nonatomic)     IBOutlet UILabel *lblSize;
@property (weak, nonatomic)     IBOutlet UIView *viewWhite;

@end
