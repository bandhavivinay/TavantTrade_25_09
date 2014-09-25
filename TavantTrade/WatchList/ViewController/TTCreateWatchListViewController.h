//
//  TTCreateWatchListViewController.h
//  TavantTrade
//
//  Created by Gautham S Shetty on 24/01/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTWatchlist.h"
@class TTCreateWatchListViewController;

@protocol CreateWatchListDelegate
//-(void)refreshTheLoadedWatchList:(int)watchlistId;
- (void) createWatchListViewControllerdidReferesh:(TTCreateWatchListViewController *)inController forWatchListId:(int)watchListId;
- (void) createWatchListViewControllerdidCancel:(TTCreateWatchListViewController *)inController;

@end

typedef enum WatchListMode {
    eDefaultMode = 0,
    eCreateMode= 1,
    eWatchlistEditableMode=2,
    eSymbolEditableMode=3
    }EWatchListMode;

@interface TTCreateWatchListViewController : UIViewController<UIAlertViewDelegate>
@property (nonatomic, assign) EWatchListMode watchListMode;
@property(nonatomic,strong)TTWatchlist *recievedWatchlistObj;
@property(atomic,assign) NSObject<CreateWatchListDelegate> *refreshWatchListDelegate;
@property (nonatomic, assign) BOOL shoulUpdateSymbols;
@property(nonatomic,assign)BOOL shouldShowBackButton;
@property(nonatomic,strong)NSString *previousScreenTitle;
@property(nonatomic,strong)TTWatchlist *tempWatchlist;
//@property(nonatomic,stron)

@end
