//
//  TTDashboardViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 12/11/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMenuViewController.h"
#import "TTMarqueeViewController.h"
#import "TTMarketViewController.h"
#import "TTQuotesViewController.h"
#import "TTTradeViewController.h"
#import "TTWatchlistController.h"
#import "TTGlobalSymbolSearchViewController.h"
#import "TTChartViewController.h"
#import "TTNewsViewController.h"
#import "TTAccountsViewController.h"
#import "TTDiffusionHandler.h"
#import "TTPositionsViewController.h"
#import "TTRecommendationViewController.h"
#import "TTOptionChainViewController.h"
#import "TTMessagesViewController.h"
#import "TTOrdersViewController.h"
#import "TTScatterMapViewController.h"
#import "TTWidgetsViewController.h"

@interface TTDashboardViewController : UIViewController<MenuItemSelection,TTMarketViewDelegate,TTQuotesViewDelegate,TTWatchlistViewDelegate,TTGlobalSymbolSearchDelegate,TTChartViewDelegate,TTNewsViewDelegate,TTAccountViewDelegate,DiffusionProtocol,TTPositionViewDelegate,TTViewsDelegate,TTOptionChainViewDelegate, TTMessagesDelegate, TTOrderViewDelegate,TTPresentTradeScreen>

@property (nonatomic, strong) IBOutlet TTWidgetsViewController *widgetsViewController;
@property (weak, nonatomic) IBOutlet UILabel *accountNumberLAbel;

@end
