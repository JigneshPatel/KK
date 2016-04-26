//
//  UIPaginationTableViewController.m
//  winkApp
//
//  Created by Temp on 16/01/15.
//  Copyright (c) 2015 kuriosthele. All rights reserved.
//

#import "UIPaginationTableViewController.h"

@implementation UIPaginationTableViewController

@synthesize pageStartIndex;

/** The current pageIndex whose data is loaded. Initial value = -1 (FEED_UNINITIALIZED_PAGE_INDEX).  */
@synthesize currentLoadedPageIndex;

/** The pageIndex whose data is requested and is pending from server.
 *  As soon as callback is received, it is reset to -1 (FEED_UNINITIALIZED_PAGE_INDEX). */
@synthesize requestedPageIndex;

/** Total number of pages available. Counting starts with 1. */
@synthesize totalPages;

/** Size of assets in each page. Default is 'FEED_PAGE_SIZE'. */
@synthesize pageBaseSize;

@synthesize requestId;

@synthesize paginationView;

- (void)initPaginationSetup{
    self.pageStartIndex = DEFAULT_PAGE_START_INDEX_FEED;
    self.pageBaseSize = FEED_PAGE_SIZE;
    self.totalPages = 1;
    self.currentLoadedPageIndex = FEED_UNINITIALIZED_PAGE_INDEX; // Initially no page is loaded, so index is un-initialized.
    self.requestedPageIndex = FEED_UNINITIALIZED_PAGE_INDEX;
}

- (void)updatePageCountForTotalAssets:(NSInteger)totalAssetCount{
    NSLog(@"");
    if (totalAssetCount == 0) {
        self.totalPages = 0;
    }else{
        
        if (self.pageBaseSize) {
            NSInteger pageOverflow = totalAssetCount % self.pageBaseSize;
            if (pageOverflow) {
                self.totalPages = (totalAssetCount / self.pageBaseSize) + 1;
            }else{
                self.totalPages = (totalAssetCount / self.pageBaseSize);
            }
            
            // Add pagination view in footer. When footer is displayed 'paginationViewDidStartAnimating' is called, where we can start loading next page.
            if ([self hasMorePages]) {
                self.tableView.tableFooterView = [self getPaginationFooterView];
            }
        }else{
            NSLog(@"*** Total number of assets in a page (pageBaseSize) cannot be '0'");
        }
    }
}


- (NSInteger)pageIndexToLoad{
    NSLog(@"");
    
    NSInteger nextPageIndex = FEED_UNINITIALIZED_PAGE_INDEX;
    if (self.totalPages == 0) {
        nextPageIndex = 0; // Todo: check of this is correct.
    }else if(self.currentLoadedPageIndex == FEED_UNINITIALIZED_PAGE_INDEX){
        
        nextPageIndex = self.pageStartIndex;  // If no page is loaded, return the start index.
    }else if(self.currentLoadedPageIndex < (self.totalPages + self.pageStartIndex)-1){
        
        // Note: 'totalPages' count start with 1 & pageIndex start with value defined by 'pageStartIndex'.
        // If totalPages = 10, pageStartIndex = 1 and currentLoadedPageIndex = 9 then,
        //   '9 < (10+1)-1' is true, and next page to load is 9+1(last page).
        nextPageIndex = self.currentLoadedPageIndex + 1;
    }
    return nextPageIndex;
}

/**
 *  Returns 'YES' if more pages exists on server.
 *   If 1st page is not yet loaded, it returns 'NO'. To load 1st page this method should not be required.
 * @note: 'currentLoadedPageIndex' starts from 'pageStartIndex', initial value is CARD_UNINITIALIZED_PAGE_INDEX.
 *   thus if totalPages = 10, pageStartIndex = 1, then
 *   currentLoadedPageIndex will have max value = 9 (i.e. 9 < (10+1)-1).
 */
- (BOOL)hasMorePages{
    NSLog(@"");
    
    BOOL morePagesExists = NO;
    if (self.totalPages > 1 &&
        self.currentLoadedPageIndex < (self.totalPages + self.pageStartIndex) - 1) {
        morePagesExists = YES;
    }else{
        NSLog(@"No mores pages for totalPages: '%ld', pageStartIndex: '%ld' & currentLoadedPageIndex: '%ld'.",
             (long)self.totalPages, (long)self.pageStartIndex, (long)self.currentLoadedPageIndex);
    }
    
    if (!morePagesExists && self.currentLoadedPageIndex == FEED_UNINITIALIZED_PAGE_INDEX) {
        NSLog(@"### First page is not loaded yet. To load 1st page 'hasMorePages' call should not be required.");
    }
    return morePagesExists;
}

- (UIView *)getPaginationFooterView{
    
    NSLog(@"");
    if (!self.paginationView) {
        wk_TableFooterPaginatorView *paginationView1 = [[wk_TableFooterPaginatorView alloc]
                                                       initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, PAGINATION_VIEW_HEIGHT_FEED)
                                                       andActionDelegate:self];
        [paginationView1 setBackgroundColor:[UIColor clearColor]];
        self.paginationView = paginationView1;
    }
    return (UIView *)self.paginationView;
}

- (void)wk_TableFooterPaginator:(wk_TableFooterPaginatorView *)pageView
              retryButtonTapped:(UIButton *)btn{
    
    NSLog(@"");
    if ([self hasMorePages]) {
        NSLog(@"*** started paging animation.");
        [self.paginationView startLoading];
        [self paginationViewDidStartAnimating];
    }
}

/**
 *  Called when pagination view appears. Should start loading next page from here.
 */
- (void)paginationViewDidStartAnimating{
    
    NSLog(@"");
    // **** To be overriden by derived class. ***
    if ([self hasMorePages]) {
        NSLog(@"*** Derived classes should override 'paginationViewDidStartAnimating' to load more pages, as these are available");
    }
}

/**
 * Method to be called by derived class, when a page is requested from server.
 */
- (void)pageIndexRequested:(NSInteger)requestedPage{
    self.requestedPageIndex = requestedPage;
    
    if (self.paginationView && !self.paginationView.activity.isAnimating) {
        [self.paginationView startLoading];
    }
    
    if (requestedPage >= (self.totalPages+self.pageStartIndex)) {
        NSLog(@"### requestedPage: '%ld' is more than bounds of max available page index.", (long)requestedPage);
    }
}

/**
 * Method must be called when success or failure callback is received for page.
 */
- (void)pageIndex:(NSInteger)receivedPageIndex didLoadSucessfully:(BOOL)didReceiveData{
    
    if (didReceiveData) {
        // Increament to pageIndex which loaded sucessfully.
        if (receivedPageIndex == self.pageStartIndex) {
            self.currentLoadedPageIndex = self.pageStartIndex;
        }
        else if(receivedPageIndex < (self.totalPages+self.pageStartIndex) ){
            self.currentLoadedPageIndex++;
        }
        else{
            NSLog(@"Received page index is beyond the total pageIndex bounds.");
        }
        
        // If no more pages are available, remove the paginaiton view.
        if ([self hasMorePages] == NO) {
            self.tableView.tableFooterView = nil;
        }
    }else{
        
        if (receivedPageIndex > self.pageStartIndex &&
            self.tableView.tableFooterView) {
            NSString *msg = @"Error while loading data. Tap to retry.";  // TODO: localize.
            [self.paginationView stopLoadingWithErrorMessage:msg];
            [self.paginationView addRetryButton];
        }else{
            NSLog(@"Not showing error message on tableFooter: '%@' for pageIndex: '%ld', .",
                 self.tableView.tableFooterView, (long)receivedPageIndex);
        }
    }
    self.requestedPageIndex = FEED_UNINITIALIZED_PAGE_INDEX;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    BOOL isEndOfTable = (scrollView.contentOffset.y >= ((scrollView.contentSize.height - PAGINATION_VIEW_HEIGHT_FEED-20) - scrollView.frame.size.height)); // Here 40 is row height
    
    if (isEndOfTable && [self hasMorePages] && (!scrollView.dragging && !scrollView.decelerating))
    {
        if (!self.tableView.tableFooterView || !self.paginationView) {
            self.tableView.tableFooterView = [self getPaginationFooterView];
            NSLog(@"****** Adding pagination footer view");
        }
        
        if (self.requestedPageIndex != [self pageIndexToLoad]) {
            
            NSLog(@"****** Load more data");
            [self.paginationView startLoading]; // Should be removed, loading animation should start only when page is requested.
            [self paginationViewDidStartAnimating];
        }else{
            NSLog(@"****** Requested sent !!");
        }
    }
    
    if (![self hasMorePages]) {
        for (UIView* view in self.paginationView.subviews) {
            [view removeFromSuperview];
        }
        self.paginationView = nil;
    }
}

@end
