//
//  wk_TableFooterPaginatorView.h
//
//  Created by Temp on 11/01/13.
//

#import <UIKit/UIKit.h>

@class wk_TableFooterPaginatorView;

@protocol wk_TableFooterPaginatorDelegate <NSObject>

- (void)wk_TableFooterPaginator:(wk_TableFooterPaginatorView *)pageView
              retryButtonTapped:(UIButton *)btn;

@end

/**
 * @class wk_TableFooterPaginatorView
 * @brief Custom view to represent the pagenation view in footer of tableview.
 */
@interface wk_TableFooterPaginatorView : UIView

@property (nonatomic, readonly) UIActivityIndicatorView *activity;
@property (nonatomic, readonly) UILabel *messageLabel;
@property (nonatomic, readonly) UIButton *retryOverlayButton;

@property (nonatomic, weak) id<wk_TableFooterPaginatorDelegate>actionDelegate;

- (id)initWithFrame:(CGRect)frame andActionDelegate:(id<wk_TableFooterPaginatorDelegate>)delegate;

- (void)stopLoadingWithErrorMessage:(NSString *)message;

- (void)addRetryButton;

- (void)startLoading;

@end
