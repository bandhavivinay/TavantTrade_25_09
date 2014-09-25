//
//  TTWatchlistController.h
//  TavantTrade
//
//  Created by Bandhavi on 1/6/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTWatchlistEntryViewController.h"
#import "TTDiffusionHandler.h"
#import "DFTopicMessage.h"
#import "TTDiffusionData.h"
#import "TTSymbolDetails.h"
#import "TTQuotesViewController.h"
#import "TTWatchlistSymbolTableCell.h"
#import "TTTradePopoverController.h"

#define GET_SIGN_INDICATOR(float) ((float > 0) ? @"+" : @"-")

@protocol TTWatchlistViewDelegate
-(void)presntQuotesView:(UIViewController *)inController;
-(void)presntTradeView:(UIViewController *)inController;
-(void)presntWatchlistEntryView:(UIViewController *)inController;
-(void)presentOrdersView:(UIViewController *)inController;
-(void)didNavigateToNewsScreen;
@end

@interface TTWatchlistController : UIViewController<LoadWatchListProtocol,DiffusionProtocol,CreateWatchListDelegate,TTWatchlistCellDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)TTWatchlist *currentDisplayedWatchlist;
@property(nonatomic,weak)IBOutlet UILabel *watchlistNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *btnAddSymbol;
@property (nonatomic, weak) IBOutlet UIButton *btnWatchlist;
@property(nonatomic,assign)id<TTWatchlistViewDelegate> watchlistDelegate;
@property(nonatomic,weak)UIViewController *parentController;
-(void)getWatchlistByid:(int)watchlistID;
-(void)getWatchList;
@end
