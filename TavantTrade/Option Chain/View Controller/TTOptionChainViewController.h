//
//  TTOptionChainViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 2/27/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTGlobalSymbolSearchViewController.h"
#import "TTDiffusionHandler.h"

#import "TTOptionChainTableViewCell.h"

@protocol TTOptionChainViewDelegate
-(void)optionChainViewControllerShouldPresentinEnlargedView:(UIViewController *)inController;
@end


@interface TTOptionChainViewController : UIViewController<TTGlobalSymbolSearchDelegate,TTGlobalSymbolSearchDelegate,DiffusionProtocol,SelectSeriesProtocol>
@property(nonatomic,weak)IBOutlet UIView *widgetView;
@property(nonatomic,assign)BOOL isEnlargedView;
@property(nonatomic,assign)BOOL isVisitedFromOtherScreen;
@property(nonatomic,assign)id<TTOptionChainViewDelegate> optionChainDelegate;
@property(nonatomic,strong)TTSymbolData *currentSymbol;

-(IBAction)showEnlargedView:(id)sender;

@end
