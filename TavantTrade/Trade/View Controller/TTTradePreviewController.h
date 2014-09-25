//
//  TTTradePreviewController.h
//  TavantTrade
//
//  Created by TAVANT on 1/23/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSymbolDetails.h"
#import "TTDiffusionHandler.h"
#import "TTOrder.h"
#define GET_SIGN_INDICATOR(float) ((float > 0) ? @"+" : @"-")

@protocol TTTradePreviewDelegate;

@interface TTTradePreviewController : UIViewController<UIAlertViewDelegate,DiffusionProtocol>
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)closePreview:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastValue;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtyValue;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeQty;
@property (weak, nonatomic) IBOutlet UILabel *validityLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *disclosedQtyValue;
@property (weak, nonatomic)  NSString *subscriptionKey;
@property (weak, nonatomic) TTSymbolDetails *symbolDetails;
@property (weak, nonatomic) TTDiffusionHandler *diffusionHandler;
@property (strong, nonatomic)  NSString *qty;
@property (strong, nonatomic)  NSString *orderType;
@property (strong, nonatomic)  NSString *durationType;
@property (strong, nonatomic)  NSString *validity;
@property (strong, nonatomic)  NSString *prodType;
@property (strong, nonatomic)  NSString *disQty;
@property (strong, nonatomic)  TTSymbolData *symbolData;
@property (strong, nonatomic)  NSString *company;
@property (strong, nonatomic)  NSString *tradeType;
@property (strong, nonatomic)  NSString *price;
@property (strong, nonatomic)  NSString *triggerPrice;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *transactionType;
@property (strong, nonatomic)NSString *exchange;
@property (strong, nonatomic) NSString*optionType;

@property (weak, nonatomic) IBOutlet UILabel *lastLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *disclosedQtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *prodTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeValidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *previewLabel;
@property(nonatomic,weak)IBOutlet UILabel *priceLabel;
@property(nonatomic,weak)IBOutlet UILabel *triggerPriceLabel;

@property(nonatomic,strong)TTOrder *currentSelectedOrder;
@property(nonatomic,assign)BOOL isModifyMode;

@property (nonatomic, assign) NSObject <TTTradePreviewDelegate> *delegate;


- (IBAction)confirmTrade:(id)sender;



@end


@protocol TTTradePreviewDelegate <NSObject>

- (void)tradePreviewControllerDidPlaceTradeSuccessfully:(TTTradePreviewController *)inController shouldShowOrders:(BOOL)showOrder;

@end
