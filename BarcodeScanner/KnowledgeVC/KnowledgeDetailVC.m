//
//  KnowledgeDetailVC.m
//  BrandReporter
//
//  Created by Gauri Shankar on 26/07/15.
//  Copyright (c) 2015 gauri shankar. All rights reserved.
//

#import "KnowledgeDetailVC.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"

@interface KnowledgeDetailVC ()
{
    IBOutlet UIImageView *imgUser;
    IBOutlet UILabel *lblBarCode,*lblManuf,*lblBrand,*lblProduct,*lblSize,*lblComment;
   IBOutlet UIWebView *webView;

}

- (IBAction)backButtonAction:(id)sender;

@end

@implementation KnowledgeDetailVC

@synthesize dictData;

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imgUser.layer.cornerRadius = imgUser.frame.size.width / 2;
    imgUser.clipsToBounds = YES;
    imgUser.layer.borderWidth = 2.0f;
    imgUser.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    NSString *strImg = dictData[@"thumbnail"];
    
//NSArray *arrImg = [strImg componentsSeparatedByString:@"\""];
    
//    NSString *strData = [arrImg objectAtIndex:1];
    
    [imgUser
     sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KBaseUrl,strImg]]
     placeholderImage:[UIImage imageNamed:@"TestImg.png"]];
    
    //[imgUser setImage:[UIImage imageNamed:dictData[@"thumbnail"]]];

    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];
    
    if([dictData[@"barcode"] isKindOfClass:[NSNull class]])
    {
        lblBarCode.text = @"";
    }
    else
    {
        lblBarCode.text = dictData[@"barcode"];
    }
    if([dictData[@"manufacture"] isKindOfClass:[NSNull class]])
    {
        lblManuf.text = @"";
    }
    else
    {
        lblManuf.text = dictData[@"manufacture"];
    }
    if([dictData[@"brand"] isKindOfClass:[NSNull class]])
    {
        lblBrand.text = @"";
    }
    else
    {
        lblBrand.text = dictData[@"brand"];
    }
    if([dictData[@"product"] isKindOfClass:[NSNull class]])
    {
        lblProduct.text = @"";
    }
    else
    {
        lblProduct.text = dictData[@"product"];
    }
    if([dictData[@"size"] isKindOfClass:[NSNull class]])
    {
        lblSize.text = @"";
    }
    else
    {
        lblSize.text = dictData[@"size"];
    }
    if([dictData[@"features"] isKindOfClass:[NSNull class]])
    {
        [webView loadHTMLString:@"" baseURL:nil];
    }
    else
    {
        //[webView loadHTMLString:dictData[@"features"] baseURL:nil];
        
        
        UIFont *font = [UIFont systemFontOfSize:35];
        
        NSString *htmlString = [NSString stringWithFormat:@"<span style=\"font-family:Helvetica; font-size: %i\">%@</span>",
                                (int) font.pointSize,
                                dictData[@"features"]];
        [webView loadHTMLString:htmlString baseURL:nil];
    }
    
    //[cell.webView loadHTMLString:dictTemp[@"thumbnails"] baseURL:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
