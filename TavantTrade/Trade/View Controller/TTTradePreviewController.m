//
//  TTTradePreviewController.m
//  TavantTrade
//
//  Created by TAVANT on 1/23/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTTradePreviewController.h"
#import "TTDiffusionHandler.h"
#import "SBITradingUtility.h"
#import "TTDiffusionData.h"
#import "TTSymbolDetails.h"
#import "SBITradingNetworkManager.h"
#import "TTUrl.h"

@interface TTTradePreviewController ()
@property(nonatomic,weak)IBOutlet UILabel *transactionTypeLabel;
@end

@implementation TTTradePreviewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    
    if(![self.subscriptionKey isEqual:[NSNull null]]){
        self.diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
        [ self.diffusionHandler subscribe:self.subscriptionKey withContext:self];
    }
    [self initialUIUpdate];
    
    _symbolLabel.font = SEMI_BOLD_FONT_SIZE(16.0);
    _companyLabel.font = SEMI_BOLD_FONT_SIZE(18.0);
    
    _lastLabel.font = _percentageChangeLabel.font = _tradeVolumeLabel.font = _transactionType.font = REGULAR_FONT_SIZE(15.0);
    
    _lastValue.font = _changeLabel.font = _volumeLabel.font = REGULAR_FONT_SIZE(13.0);
    _transactionTypeLabel.font = BOLD_FONT_SIZE(18.0);
    
    _orderTypeLabel.font = _qtyLabel.font = _tradeValidityLabel.font = _prodTypeLabel.font = _disclosedQtyLabel.font = _disclosedQtyValue.font = _productTypeLabel.font = _validityLabel.font = _qtyValue.font = _orderTypeQty.font = REGULAR_FONT_SIZE(16.0);
    
    _confirmButton.titleLabel.font = _backButton.titleLabel.font = SEMI_BOLD_FONT_SIZE(15.0);
    _previewLabel.font = SEMI_BOLD_FONT_SIZE(22.0);
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    _previewLabel.text=NSLocalizedStringFromTable(@"Trade_Preview", @"Localizable", @"Trade Preview");
    _percentageChangeLabel.text=NSLocalizedStringFromTable(@"Change", @"Localizable", @"Change");
    _lastLabel.text=NSLocalizedStringFromTable(@"Last", @"Localizable", @"Last");
    _tradeVolumeLabel.text=NSLocalizedStringFromTable(@"Volume", @"Localizable", @"Volume");
    _qtyLabel.text=NSLocalizedStringFromTable(@"Qty", @"Localizable", @"Quantity");
    _orderTypeLabel.text=NSLocalizedStringFromTable(@"Order_Type", @"Localizable", @"Order Type");
    _disclosedQtyLabel.text=NSLocalizedStringFromTable(@"Dis_Qty", @"Localizable", @"Quantity");
    _tradeValidityLabel.text=NSLocalizedStringFromTable(@"Validity", @"Localizable", @"Validity");
    _prodTypeLabel.text=NSLocalizedStringFromTable(@"Product_Type", @"Localizable", @"Product Type");
    [_confirmButton setTitle:NSLocalizedStringFromTable(@"Confirm_Button_Title", @"Localizable", @"Confirm") forState:UIControlStateNormal];
    [_backButton setTitle:NSLocalizedStringFromTable(@"Back_Button_Title", @"Localizable", @"Back") forState:UIControlStateNormal];
   
}

// updating UI taking the values from trade screen
-(void)initialUIUpdate{
  
    self.symbolLabel.text=self.symbolData.tradeSymbolName;
    self.companyLabel.text=self.company;
    
    self.orderTypeQty.text=self.orderType;
    self.validityLabel.text=self.validity;
    self.productTypeLabel.text=self.prodType;
    if([self.disQty isEqualToString:@""])
        self.disQty = @"0";
    self.disclosedQtyValue.text=self.disQty;
//    else
//        self.disclosedQtyValue.text= @"0";

    self.transactionType.text=self.tradeType;
    
    NSString *quantityText = @"";
    
    if([self.tradeType isEqualToString:@"Sell"]){
        self.qtyValue.textColor = _transactionTypeLabel.textColor = SYMBOL_LOSS_LABEL_COLOR;
        quantityText = [NSString stringWithFormat:@"- %@",self.qty];
    }
    else{
        _transactionTypeLabel.textColor = SYMBOL_PROFIT_LABEL_COLOR;
        quantityText = self.qty;
    }
    self.qtyValue.text=quantityText;
    
    self.exchange=self.symbolDetails.symbolData.exchange;
    self.optionType=self.symbolDetails.symbolData.instrumentType;
    // hardcoding for time being
    //self.optionType=[SBITradingUtility getTitleForInstrumentType:EQUITY];
    if([self.price length] > 0)
        self.priceLabel.text = self.price;
    else{
        self.price = @"0";
        self.priceLabel.text = @"0";
    }
    
    if([self.triggerPrice length] > 0)
        self.triggerPriceLabel.text = self.triggerPrice;
//    else
//        self.triggerPriceLabel.text = @"NA";
    
    _transactionTypeLabel.text = self.tradeType;
    
   // [_confirmButton setTitle:self.tradeType forState:UIControlStateNormal];
    
}

-(void)onDelta:(DFTopicMessage *)message{
    
    //find the row to be updated...
    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
    TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
    diffusionData = [diffusionData updateDiffusionDataWith:parsedArray];
//    if([diffusionData.symbolData.subscriptionKey isEqualToString: @"REPORTS/TEST/EXRS"]){
//        
//    }
    [self updateUI:diffusionData];
}

-(void)updateUI:(TTDiffusionData *) diffusionData{
    float priceChange = diffusionData.lastSalePrice-diffusionData.closingPrice;
    if([diffusionData.netPriceChangeIndicator isEqualToString:@""])
        diffusionData.netPriceChangeIndicator = GET_SIGN_INDICATOR(priceChange);
    float percentage = 0.00;
    if(diffusionData.closingPrice != 0)
        percentage = (fabsf(priceChange)/diffusionData.closingPrice)*100;
    if(isnan(percentage)){
        percentage = 0.00;
    }
    self.changeLabel.text = [NSString stringWithFormat:@"%@%.02f(%@%.02f%%)",diffusionData.netPriceChangeIndicator,fabsf(priceChange),diffusionData.netPriceChangeIndicator,percentage];
    self.volumeLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.volume] ;
    self.lastValue.text=[NSString stringWithFormat:@"%.02f",diffusionData.lastSalePrice];
    //self.changeLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.netPriceChange];
   
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)closePreview:(id)sender {
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)confirmTrade:(id)sender {
    [self  showAlert: NSLocalizedStringFromTable(@"Trade_Confirm", @"Localizable",@"Would you like to confirm the trade?") :1];
   }

-(void) showAlert: (NSString *) message : (int) tag{
    
    if(tag==1){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Confirmation_Title", @"Localizable", @"Confirmation")
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Cancel",nil];
    [alert show];
    alert.tag=tag;
    }
    
    else if(tag == 3){
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"TradeStatus_Title", @"Localizable", @" Trade status")
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:@"Go To Order Book",nil];
        [alert1 show];
        alert1.tag=tag;
    }
    
    else{
        
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"TradeStatus_Title", @"Localizable", @" Trade status")
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert1 show];
        alert1.tag=tag;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1){
        switch(buttonIndex){
            case 0:{[self placeTrade];
                break;
            }
            case 1 :{ break;
            }
                
        }
    }
    else if(alertView.tag == 3)
    {
        BOOL shouldShow = NO;
        switch(buttonIndex){
            case 0:{
                shouldShow = NO;
                break;
            }
            case 1 :{
                
               // [] 
                shouldShow = YES;
                break;
            }
        }
        if(_delegate && [ _delegate respondsToSelector:@selector(tradePreviewControllerDidPlaceTradeSuccessfully:shouldShowOrders:)])
        {
            [_delegate tradePreviewControllerDidPlaceTradeSuccessfully:self shouldShowOrders:shouldShow];
        }

    }
    
    
}

// placing the trade with details given
-(void)placeTrade{
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    NSString *relativePath = [TTUrl modifyOrderURL];
    NSMutableDictionary *postBodyDictionary=[self createTradeData];
    
    NSString *alertMessage = NSLocalizedStringFromTable(@"Order_Success", @"Localizable",@"Order placed successfully");

    if(self.isModifyMode){
        
        relativePath = [TTUrl modifyOrderURL];
        [postBodyDictionary setValue:self.currentSelectedOrder.orderID forKey:@"nestOrdNumber"];
        [postBodyDictionary setValue:@"" forKey:@"exchAlgoId"];
        [postBodyDictionary setValue:@"" forKey:@"exchAlgoSeqNum"];
        [postBodyDictionary setValue:self.currentSelectedOrder.origClOrdID forKey:@"origClOrdID"];
       // [postBodyDictionary setValue:@"1" forKey:@"handlInst"];
       // [postBodyDictionary setValue:self.currentSelectedOrder.exchangeType forKey:@"exDestination"];
        [postBodyDictionary setValue:self.currentSelectedOrder.orderID forKey:@"nestRequestId"];
       // [postBodyDictionary setValue:self.currentSelectedOrder.isAmo forKey:@"AMO"];
        
        //TODO:Bandhavi
        
        [postBodyDictionary setValue:@"open" forKey:@"status"];
        [postBodyDictionary setValue:@"0" forKey:@"mktProtection"];
        [postBodyDictionary setValue:@"open" forKey:@"status"];
        [postBodyDictionary setValue:@"string" forKey:@"clientData"];

        
//        if([self.currentSelectedOrder.priceType caseInsensitiveCompare:@"Limit"] == NSOrderedSame){
//            [postBodyDictionary setValue:self.price forKey:@"price"];
//        }
//        else if ([self.currentSelectedOrder.priceType caseInsensitiveCompare:@"stoploss"] == NSOrderedSame){
//            [postBodyDictionary setValue:self.price forKey:@"price"];
//            [postBodyDictionary setValue:self.triggerPrice forKey:@"stopLossTriggerPrice"];
//        }
//        else if([self.currentSelectedOrder.priceType caseInsensitiveCompare:@"stoplossmarket"] == NSOrderedSame){
//            [postBodyDictionary setValue:self.triggerPrice forKey:@"stopLossTriggerPrice"];
//        }
        
        NSLog(@"%@",postBodyDictionary);
//        
//        [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:postBodyDictionary responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
//            
//            NSError *jsonParsingError = nil;
//            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
//            NSLog(@"Order Response is %@",responseDictionary);
//            
//            if([data length] > 0){
//                
//                NSError *jsonParsingError = nil;
//                NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
//                NSLog(@"%@",responseArray);
//            }
//            
//        }];

    }
    else{
        NSLog(@"Dictionary is: %@",postBodyDictionary);
        relativePath = [TTUrl tradeOrderURL];
        [postBodyDictionary setValue:@"C" forKey:@"customerFirm"];
        [postBodyDictionary setValue:self.symbolData.tradeSymbolName forKey:@"symbol"];
        
        alertMessage = NSLocalizedStringFromTable(@"Order_Modify_Success", @"Localizable",@"Order placed successfully");
        
//        [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:postBodyDictionary responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
//            
//            NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
//            if(recievedResponse.statusCode != 200 && recievedResponse.statusCode !=404)
//            {
//                [self showAlert:NSLocalizedStringFromTable(@"Order_Failure", @"Localizable",@"Order is not placed successfully") :0];
//            }
//            else{
//                [self showAlert:NSLocalizedStringFromTable(@"Order_Success", @"Localizable",@"Order placed successfully") :0];
//                
//                if(_delegate && [ _delegate respondsToSelector:@selector(tradePreviewControllerDidPlaceTradeSuccessfully:)])
//                {
//                    [_delegate tradePreviewControllerDidPlaceTradeSuccessfully:self];
//                }
//                
//            }
//            
//            //Temporary Code to handle the 404 error.
//            
//        }];
    }
    
    [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:postBodyDictionary responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
        if(recievedResponse.statusCode != 200 && recievedResponse.statusCode !=404)
        {
            [self showAlert:NSLocalizedStringFromTable(@"Request_Failure", @"Localizable",@"Unable to process the request") :0];
        }
        else{
            [self showAlert:alertMessage :3];
            if([data length] > 0){
                
                NSError *jsonParsingError = nil;
                NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
                NSLog(@"%@",responseArray);
            }

            
        }
    }];
    
}

// creating the dictionary for post body
-(NSMutableDictionary *) createTradeData{
    int qty=(int)self.qty;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * today = [formatter stringFromDate:[NSDate date]];
       NSLog(@"Date format is %@",today);
    
    NSString *orderTypeString = @"";
    
    if([self.orderType isEqualToString:@"SL-L"])
        orderTypeString = @"Stop Loss";
    else if([self.orderType isEqualToString:@"SL-M"])
        orderTypeString = @"Stop Loss-Market";
    else
        orderTypeString = self.orderType;
    
    NSString *disclosedQtyKey = @"disclosedQty";
    if(self.isModifyMode)
        disclosedQtyKey = @"disclosedQuantity";
    
           NSArray *objects= [[NSArray alloc] initWithObjects:
                    self.exchange,qty ,orderTypeString,self.symbolData.symbolToken,self.tradeType,
                              self.optionType,self.validity,today,self.disQty,self.prodType,@"TEST",nil];
        NSArray *keys=[[NSArray alloc] initWithObjects: @"iDSource",@"orderQty",@"ordType",@"securityID",@"side",@"securityType",@"timeInForce",@"transactTime",disclosedQtyKey,
                       @"productType",@"clientID",nil];
    
       NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
    
    NSString *stopLossKey = @"stopLossTriggerPrice";
    if(self.isModifyMode)
        stopLossKey = @"stopLossTriggerValue";
   
    if([self.orderType isEqualToString:@"Limit"]){
        [dict setObject:self.price forKey:@"price"];
        [dict setObject:@"0" forKey:stopLossKey];
    }
    else if([self.orderType isEqualToString:@"SL-L"]){
        [dict setObject:self.price forKey:@"price"];
        [dict setObject:self.triggerPrice forKey:stopLossKey];
    }
    else if([self.orderType isEqualToString:@"SL-L"]){
        [dict setObject:self.triggerPrice forKey:stopLossKey];
    }
    else{
        [dict setObject:@"0" forKey:@"price"];
        [dict setObject:@"0" forKey:stopLossKey];
    }
//    else{
//        [dict setObject:self.price forKey:@"price"];
//        [dict setObject:@"0" forKey:@"stopLossTriggerValue"];
//    }
 
    // check for future Stock and index
    if([self.optionType isEqualToString:@"FUTIDX"]||[self.optionType isEqualToString:@"FUTSTK"]||[self.optionType isEqualToString:@"FUTCUR"])
    {
        //[dict setValue:@"FUTURES" forKey:@"securityType"];
    }
    else if([self.optionType isEqualToString:@"OPTSTK"]||[self.optionType isEqualToString:@"OPTIDX"]||[self.optionType isEqualToString:@"OPTCUR"])
    {
       // [dict setValue:@"OPTIONS" forKey:@"securityType"];
    }
    
//    [dict setValue:@"" forKey:@"origClOrdID"];
//    [dict setValue:@"" forKey:@"nestOrdNumber"];
//    [dict setValue:@"1" forKey:@"handlInst"];
//    [dict setValue:self.exchange forKey:@"exDestination"];
//    [dict setValue:@"" forKey:@"nestRequestId"];
//    [dict setValue:@"false" forKey:@"AMO"];
  
   
    return dict;
}

@end
