//
//  igViewController.m
//  ScanBarCodes
//

//

#import <AVFoundation/AVFoundation.h>
#import "igViewController.h"
#import "SnapVC.h"
#import "AppDelegate.h"
#import "NVSlideMenuController.h"

@interface igViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;

    UIView *_highlightView;
    UILabel *_label;
    UIButton *_btn;
    UIStoryboard *storyboard;
    AppDelegate *delegate;
}

- (IBAction)nextButtonAction:(id)sender;

@end

@implementation igViewController

- (IBAction)nextButtonAction:(id)sender
{
    [delegate.dictRecord setValue:_label.text forKey:@"BarCode"];
    
    storyboard = [AppDelegate storyBoardType];
    
    SnapVC *objVC = (SnapVC*)[storyboard instantiateViewControllerWithIdentifier:@"SnapVCId"];
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    
    
}

#pragma mark FOR LEFT MENU ITEM

- (IBAction)backButtonAction:(id)sender {
    
    if (!look)
    {
        [self.slideMenuController openMenuAnimated:YES completion:nil];
        
    }
    
    else
    {
        [self.slideMenuController closeMenuAnimated:YES completion:nil];
    }
    
    
    look=!look;
    
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES];

    [super viewDidLoad];

    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor blueColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];

    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor blueColor];
    _label.textAlignment = NSTextAlignmentCenter;
    //_label.text = @"Next";
    //[self.view addSubview:_label];

    _btn = [[UIButton alloc] init];
    _btn.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _btn.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    [_btn addTarget:self
            action:@selector(btnSelected:)
  forControlEvents:UIControlEventTouchUpInside];
   // [self.view addSubview:_btn];
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;

    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }

    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];

    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];

    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];

    [_session startRunning];

    [self.view bringSubviewToFront:_highlightView];
    //[self.view bringSubviewToFront:_label];
    
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    [viewTop setBackgroundColor:[UIColor blackColor]];
    
    UILabel *lblNext = [[UILabel alloc] init];
    lblNext.frame = CGRectMake(266,38, 46, 12);
    lblNext.textColor = [UIColor whiteColor];
    lblNext.text = @"Next";
    [viewTop addSubview:lblNext];

    UIButton *btnNext = [[UIButton alloc] init];
    btnNext.frame = CGRectMake(266,20, 100, 50);
    //[btnNext setTitle:@"Next" forState:UIControlStateNormal];
    //btnNext.titleLabel.textColor = [UIColor whiteColor];
    [btnNext addTarget:self
                action:@selector(nextButtonAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:btnNext];
    
    UIButton *btnBack = [[UIButton alloc] init];
    btnBack.frame = CGRectMake(0, 15, 70, 55);
    [btnBack setImage:[UIImage imageNamed:@"menu icon.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self
                action:@selector(backButtonAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:btnBack];
    
    UILabel *lblTag = [[UILabel alloc] init];
    lblTag.frame = CGRectMake(150, 35, 113, 21);
    lblTag.textColor = [UIColor whiteColor];
    lblTag.text = @"Scan";
    
    [viewTop addSubview:lblTag];
    
    [self.view addSubview:viewTop];
    [self.view bringSubviewToFront:viewTop];
    
//    UIView *viewLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 70, 320, 500)];
//    [viewLayer setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"scan_bg.png"]]];
//    [self.view addSubview:viewLayer];
//
//    [self.view bringSubviewToFront:viewLayer];

}

-(void)btnSelected:(UIButton *)button
{
   // NSLog(@"Button %ld Clicked",(long int)[button tag]);
    
   //[delegate.dictRecord setValue:_label.text forKey:@"BarCode"];

    storyboard = [AppDelegate storyBoardType];
    
    SnapVC *objVC = (SnapVC*)[storyboard instantiateViewControllerWithIdentifier:@"SnapVCId"];
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    

    
}

static BOOL hasOutput;
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (!hasOutput
        && metadataObjects.count > 0 ) {
        hasOutput=YES;
        
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
    
        
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];

    for (AVMetadataObject *metadata in metadataObjects)
    {
        for (NSString *type in barCodeTypes)
        {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                
                
                break;
            }
        }

        if (detectionString != nil)
        {
            
            [delegate.dictRecord setValue:_label.text forKey:@"BarCode"];

            _label.text = detectionString;
        }
        else
        {
            _label.text = @"";
        }
        
        NSLog(@"detectionString %@",detectionString);
        
        break;

    }
        
        _highlightView.frame = highlightViewRect;

    }
    
}
    
-(void)stopReading
{
        NSLog(@"stop reading");
    
    
        [_session stopRunning];
        _session = nil;
        hasOutput=NO;
        [_prevLayer removeFromSuperlayer];
    
    [delegate.dictRecord setValue:_label.text forKey:@"BarCode"];

    storyboard = [AppDelegate storyBoardType];
    
    SnapVC *objVC = (SnapVC*)[storyboard instantiateViewControllerWithIdentifier:@"SnapVCId"];
    [self.navigationController pushViewController:objVC animated:YES];
    objVC = nil;
    
}

@end