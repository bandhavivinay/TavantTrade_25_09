//
//  TTWatchlistEntryViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 12/11/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTWatchListTableViewCell.h"
#import "TTCreateWatchListViewController.h"
#import "TTSymbolData.h"

@protocol LoadWatchListProtocol
-(void)loadSymbolsForWatchList:(NSArray *)rawDataArray andWatchlistObject:(TTWatchlist *)watchlistObj;
-(void)refreshWatchlist:(TTWatchlist *)inWatchlist;
-(void)showWatchlist:(TTWatchlist *)watchlist;
//-(void)dismissThePopOver;
@end

@interface TTWatchlistEntryViewController : UIViewController<SelectWatchlistProtocol,UITableViewDataSource,UITableViewDelegate,CreateWatchListDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *watchlistEntryTitle;
@property(nonatomic,assign)id <LoadWatchListProtocol> loadWatchlistDelegate;
@property(nonatomic,strong)UIViewController *parentController;
@property(nonatomic,assign)BOOL isCalledFromOtherScreen;
@property(nonatomic,strong)TTSymbolData *currentSymbol;
@property(nonatomic,assign)BOOL shouldShowBackButton;
@property(nonatomic,strong)NSString *previousScreenTitle;
@property(nonatomic,assign)CGRect previousScreenFrame;

@end
