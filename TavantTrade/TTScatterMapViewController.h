//
//  ScatterMapViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 5/20/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTScatterMapSymbolView.h"
#import "TTHeatMapSymbolView.h"
#import "TTTradePopoverController.h"

@protocol TTPresentTradeScreen

-(void)tradeNavigationViewControllerShouldPresent:(UIViewController *)inController;

@end

@interface TTScatterMapViewController : UIViewController<TTSymbolViewDelegate,TTHeatMapSymbolViewDelegate,UIScrollViewDelegate>
@property(nonatomic,weak)id<TTPresentTradeScreen> ttTradeScreenDelegate;
@end
