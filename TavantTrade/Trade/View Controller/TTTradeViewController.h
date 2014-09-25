//
//  TTTradeViewController.h
//  TavantTrade
//
//  Created by TAVANT on 1/21/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTradePopoverController.h"
#import "TTDiffusionHandler.h"

@interface TTTradeViewController : UIViewController<DiffusionProtocol>
@property(nonatomic, weak) IBOutlet UIButton *tradeButton;
@property(nonatomic,strong) TTTradePopoverController *tradePopOver;
@property (weak, nonatomic) IBOutlet UILabel *symbolNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *askValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *highValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *ltpLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *bidLabel;
@property (weak, nonatomic) IBOutlet UILabel *askLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *acountNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *acountNumberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTicketLabel;

- (IBAction)showEnlargedView:(id)sender;
//- (IBAction)openTradePopOver:(id)sender;

@end
