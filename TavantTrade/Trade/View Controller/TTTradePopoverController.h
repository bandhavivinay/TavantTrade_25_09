//
//  TTTradePopoverController.h
//  TavantTrade
//
//  Created by TAVANT on 1/22/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDiffusionHandler.h"
#import "TTConstants.h"
#import "TTTradePreviewController.h"
#import "TTOrder.h"
// enums for dropdown popovers

@protocol TTTradePopoverDelegate;

@interface TTTradePopoverController : UIViewController<UITextFieldDelegate,DiffusionProtocol, TTTradePreviewDelegate>


@property (nonatomic, strong) IBOutlet UIView *popOverView;
@property (weak, nonatomic) IBOutlet UILabel *symbolNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ltpLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageChangeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *bidValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *highValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *askValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *transactionTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *productTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *orderTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *durationButton;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroller;
@property(nonatomic,strong)NSString *previousScreenTitle;
@property(nonatomic,assign)CGRect previousScreenFrame;
@property(nonatomic,assign)BOOL shouldShowBackButton;

//@property(nonatomic,strong)TTSymbolData *selectedSymbol;
@property(nonatomic,strong)TTOrder *tradeDataSource;

@property(nonatomic,assign)BOOL isModifyMode;

//@property(nonatomic,strong) 


@property (weak, nonatomic) IBOutlet UITextField *txtQuantity;
@property (weak, nonatomic) IBOutlet UITextField *txtDisclosedQuantity;
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (weak, nonatomic) IBOutlet UITextField *txtTriggeredPrice;

@property(nonatomic,strong) TTTradePreviewController *tradepreview;
@property (weak, nonatomic) IBOutlet UITableView *listingTableView;

@property (nonatomic, assign) EDuration durationType;
@property (nonatomic, assign) EOrderType orderType;
@property (nonatomic, assign) EProductType productType;
@property (nonatomic, assign) ETransactionType transactionType;
@property (nonatomic, assign) ETradingOptionsType selectedTradingOptionType;


@property (weak, nonatomic) IBOutlet UILabel *bidLabel;
@property (weak, nonatomic) IBOutlet UILabel *askLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *accNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTicketLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *disclosedQtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *triggeredPriceLabel;
@property (nonatomic, assign) NSObject <TTTradePopoverDelegate> *delegate;




- (IBAction)closeTradeView:(id)sender;
- (IBAction)onTransactionTypeClick:(id)sender;
- (IBAction)onproductTypeclick:(id)sender;
- (IBAction)onDurationCLick:(id)sender;
- (IBAction)onOrderTypeClick:(id)sender;
- (IBAction)openPreviewPage:(id)sender;
@end


@protocol TTTradePopoverDelegate <NSObject>

- (void)tradePopoverControllerDidPlaceTradeSuccessfully:(TTTradePopoverController *)inController  shouldShowOrders:(BOOL)showOrder;

@end
