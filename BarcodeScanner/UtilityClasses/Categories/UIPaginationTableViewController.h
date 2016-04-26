//
//  UIPaginationTableViewController.h
//  winkApp
//
//  Created by Temp on 16/01/15.
//  Copyright (c) 2015 kuriosthele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wk_TableFooterPaginatorView.h"

/**
 *   @def FEED_PAGE_SIZE
 *   The size of eack page to requested from server. */
#define FEED_PAGE_SIZE 10

/**
 *   @def PAGINATION_VIEW_HEIGHT_FEED
 *   The height of view used for pagination, in the table footer.
 */
#define PAGINATION_VIEW_HEIGHT_FEED 40

/**
 *   @def DEFAULT_PAGE_START_INDEX_FEED
 *   Default page start index for feeds.
 */
#define DEFAULT_PAGE_START_INDEX_FEED 1

/**
 *   @def FEED_UNINITIALIZED_PAGE_INDEX
 *   Index when a pageIndex value is not yet initialized.
 */
#define FEED_UNINITIALIZED_PAGE_INDEX -1

@interface UIPaginationTableViewController : UITableViewController <wk_TableFooterPaginatorDelegate>

/* ******
 * Pagination related, to be used by derived classes.
 * ******
 */

/** The start index for page(0, 1 etc), should be set only once.
 *   Preferably to be set when assigning total asset count 'updatePageCountForTotalAssets:' */
@property (nonatomic, readwrite) NSInteger pageStartIndex;

/** The current pageIndex whose data is loaded. Initial value = -1 (FEED_UNINITIALIZED_PAGE_INDEX).  */
@property (nonatomic, readwrite) NSInteger currentLoadedPageIndex;

/** The pageIndex whose data is requested and is pending from server.
 *  As soon as callback is received, it is reset to -1 (FEED_UNINITIALIZED_PAGE_INDEX). */
@property (nonatomic, readwrite) NSInteger requestedPageIndex;

/** Total number of pages available. Counting starts with 1. */
@property (nonatomic, readwrite) NSInteger totalPages;

/** Size of assets in each page. Default is 'FEED_PAGE_SIZE'. */
@property (nonatomic, readwrite) NSInteger pageBaseSize;

@property (nonatomic, assign)   NSInteger requestId;

@property (nonatomic, strong) wk_TableFooterPaginatorView *paginationView;

/** Update the total page count, based on the total number of assets available from API response.
 */
- (void)updatePageCountForTotalAssets:(NSInteger)totalAssetCount;

/** The index of page for which data needs to load next.
 */
- (NSInteger)pageIndexToLoad;

/** Returns 'YES' if more pages exists on server.
 */
- (BOOL)hasMorePages;

/**
 * Method to be overriden by derived classes, where request to load next page can be made.
 *  Method is called when the pagination view first appears. Not called when pagination view
 *  reappears for same page. So its safe to call API request here without need for check
 *  against duplicate page requests.
 *
 * @discussion: If page is requested in this method, it is imporatant to call method
 *   'pageIndex: didLoadSucessfully:'.
 */
- (void)paginationViewDidStartAnimating;

/**
 * Method to be called by derived class, when a page is requested from server.
 */
- (void)pageIndexRequested:(NSInteger)requestedPage;

/**
 * Method must be called when sucess or failure callback is received for a page.
 */
- (void)pageIndex:(NSInteger)receivedPageIndex didLoadSucessfully:(BOOL)didReceiveData;

#pragma mark -

@end
