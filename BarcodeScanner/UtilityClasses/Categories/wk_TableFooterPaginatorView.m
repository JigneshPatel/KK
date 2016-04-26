//
//  wk_TableFooterPaginatorView.m
//
//  Created by Temp on 11/01/13.
//

#import "wk_TableFooterPaginatorView.h"

@interface wk_TableFooterPaginatorView ()

@property (nonatomic, strong, readwrite) UIActivityIndicatorView *activity;
@property (nonatomic, strong, readwrite) UILabel *messageLabel;
@property (nonatomic, strong, readwrite) UIButton *retryOverlayButton;

@end

@implementation wk_TableFooterPaginatorView

- (id)initWithFrame:(CGRect)frame andActionDelegate:(id<wk_TableFooterPaginatorDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        [self initSubViewsWithFrame:frame];
        
        self.actionDelegate = delegate;
    }
    return self;
}

- (void)initSubViewsWithFrame:(CGRect)frame{

    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setHidesWhenStopped:YES];
    [activity startAnimating];
    CGRect activityFrame = CGRectMake(15, 10, 20, 20);
    [activity setFrame:activityFrame];
    self.activity = activity;
    [self addSubview:activity];
    
    UILabel *messageLabel = [[UILabel alloc]
                             initWithFrame:CGRectMake((activityFrame.origin.y+activityFrame.size.width+10),
                                                      10,
                                                      frame.size.width-(activityFrame.origin.y+activityFrame.size.width+15),
                                                      20)];

    messageLabel.textAlignment = NSTextAlignmentLeft;
    [messageLabel setText:@"Loading..."];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setTextColor:[UIColor lightGrayColor]];
    self.messageLabel = messageLabel;
    [self addSubview:messageLabel];
}

- (void)layoutSubviews{
    
    if (self.activity) {
        [self.activity setFrame:CGRectMake(15, 10, 20, 20)];
    }
    
    if (self.messageLabel) {
        CGRect activityFrame = self.activity.frame;
        CGRect msgFrame = CGRectMake((activityFrame.origin.y+activityFrame.size.width+10),
                                     10,
                                     self.frame.size.width-(activityFrame.origin.y+activityFrame.size.width+15),
                                     20);
        [self.messageLabel setFrame:msgFrame];
    }
    
    if (self.retryOverlayButton) {
        [self.retryOverlayButton setFrame:self.bounds];
    }
    
    [super layoutSubviews];
}

- (void)dealloc{
    self.actionDelegate = nil;
    
    self.activity = nil;
    self.messageLabel = nil;
    self.retryOverlayButton = nil;
}

- (void)startLoading{    
    [self.activity startAnimating];
    [self.messageLabel setText:@"Loading..."];
}

- (void)stopLoadingWithErrorMessage:(NSString *)message{
    
    [self.activity stopAnimating];
    [self.messageLabel setText:message];
}

- (void)addRetryButton{
    
    if (!self.retryOverlayButton) {
        self.retryOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.retryOverlayButton setFrame:self.bounds];
        [self.retryOverlayButton addTarget:self
                                    action:@selector(retryButtonTapped:)
                          forControlEvents:UIControlEventTouchDragInside];
        [self addSubview:self.retryOverlayButton];
    }
}

- (void)retryButtonTapped:(id)sender{
    
    if (self.actionDelegate &&
        [self.actionDelegate conformsToProtocol:@protocol(wk_TableFooterPaginatorDelegate)]) {
        [self.actionDelegate wk_TableFooterPaginator:self retryButtonTapped:(UIButton *)sender];
    }
}

@end
