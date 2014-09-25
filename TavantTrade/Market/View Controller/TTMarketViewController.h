//
//  TTMarketViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 1/15/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTConstants.h"
#import "TTDiffusionHandler.h"
#import "TTDiffusionData.h"

@class TTMarketViewController;

#define GET_SIGN_INDICATOR(float) ((float > 0) ? @"+" : @"-")

@protocol TTMarketViewDelegate
-(void)marketViewControllerShouldPresentinEnlargedView:(UIViewController *)inController;
@end

@interface TTMarketViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DiffusionProtocol>

@property (weak, nonatomic) IBOutlet UILabel *marketTitle;
@property (weak, nonatomic) IBOutlet UILabel *widgetMarketTitle;
@property(nonatomic,weak)IBOutlet UIView *widgetView;
@property(nonatomic,strong) UINavigationController *selfNavigationController;
@property(nonatomic,assign)id<TTMarketViewDelegate> presentEnlargedViewDelegate;
-(void)segmentControlDidChangeIndex:(id)sender;
-(IBAction)showEnlargedView:(id)sender;

@end
