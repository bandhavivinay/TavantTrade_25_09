//
//  TTQuotesViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 1/15/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDiffusionHandler.h"
#import "TTConstants.h"
#import "TTTradePopoverController.h"

@class TTQuotesViewController;

#define GET_SIGN_INDICATOR(float) ((float > 0) ? @"+" : @"-")

@protocol TTQuotesViewDelegate
-(void)quotesViewControllerShouldPresentinEnlargedView:(UIViewController *)inController;
-(void)tradeViewControllerShouldPresentinEnlargedView:(TTTradePopoverController *)inController;
@end

@interface TTQuotesViewController : UIViewController<DiffusionProtocol, TTTradePopoverDelegate>
@property (weak, nonatomic) IBOutlet UILabel *quotesTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *addToWatchlistButton;
@property (weak, nonatomic) IBOutlet UILabel *lastLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *quotesWidgetlabel;
@property (weak, nonatomic) IBOutlet UILabel *lastWidgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeWidgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeWidgetLabel;
@property(nonatomic,weak)IBOutlet UIView *widgetView;
@property(nonatomic,assign)id<TTQuotesViewDelegate> ttQuotesDelegate;
@property(nonatomic,assign)BOOL shouldShowBackButton;
@property(nonatomic,strong)NSString *previousScreenTitle;
@property(nonatomic,assign)CGRect previousScreenFrame;

-(IBAction)showEnlargedView:(id)sender;

@end
