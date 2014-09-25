//
//  TTAccountsViewController.h
//  TavantTrade
//
//  Created by TAVANT on 1/31/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDiffusionHandler.h"
#import "TTAccountLienCell.h"

#import "TTLienWebViewController.h"


@class TTAccountsViewController;

@protocol TTAccountViewDelegate
-(void)AccountViewControllerShouldPresentinEnlargedView:(UIViewController *)inController;
@end


@interface TTAccountsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,DiffusionProtocol,TTAccountButtonDelegate>

@property (weak, nonatomic) IBOutlet UILabel *accountNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
//@property (weak, nonatomic) IBOutlet UIButton *clientButton;
//@property (weak, nonatomic) IBOutlet UIButton *cashButton;
//@property (weak, nonatomic) IBOutlet UIButton *foButton;
//@property (weak, nonatomic) IBOutlet UIButton *currencyButton;
@property(nonatomic,assign)BOOL isEnlargedView;
//@property (weak, nonatomic) IBOutlet UIButton *enlargedClientButton;
//@property (weak, nonatomic) IBOutlet UIButton *enlargedCashButton;
//@property (weak, nonatomic) IBOutlet UIButton *enlargedFoButton;
//@property (weak, nonatomic) IBOutlet UIButton *enlargedCurButton;

@property (weak, nonatomic) IBOutlet UITableView *accountsEnlargedTableView;
@property(nonatomic,weak)IBOutlet UIView *widgetView;
@property(nonatomic,assign)id<TTAccountViewDelegate> presentEnlargedViewDelegate;

@property(nonatomic,strong) UINavigationController *selfNavigationController;

@property (weak, nonatomic) IBOutlet UILabel *widgetAccountIdLabel;

@property (weak, nonatomic) IBOutlet UILabel *widgetLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *widgetTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *enlargerAccountIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *enlargedLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *enlargedAccountTitleLabel;
@property(nonatomic,weak)IBOutlet UISegmentedControl *segmentControl;
@property(nonatomic,weak)IBOutlet UISegmentedControl *widgetSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView *accountsWidgetTableView;

-(IBAction)showEnlargedView:(id)sender;


@end
