//
//  TTWidgetsViewController.h
//  TavantTrade
//
//  Created by Gautham S Shetty on 10/01/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTWidgetsContainerView.h"
#import "TTConstants.h"
#import "TTTradeViewController.h"
//#import "TTDashboardViewController.h"
#import "TTAccountsViewController.h"
#import "TTDiffusionHandler.h"
@class TTDashboardViewController;

@interface TTWidgetsViewController : UIViewController<TTWidgetsContainerDatasource,UIGestureRecognizerDelegate,DiffusionProtocol>
@property(nonatomic,assign)EExchangeType exchangeType;
@property(nonatomic,assign)IBOutlet TTDashboardViewController *dashBoardController;
@property (nonatomic,strong) TTTradeViewController* tradeViewController;
@property (nonatomic,strong) TTAccountsViewController* accountsViewController;
-(void) showWidgetsofType:(EApplicationMenuItems)inType;
@end
