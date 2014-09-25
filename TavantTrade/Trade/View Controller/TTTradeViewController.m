//
//  TTTradeViewController.m
//  TavantTrade
//
//  Created by TAVANT on 1/21/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTTradeViewController.h"
#import "TTSymbolDetails.h"
#import "TTDiffusionData.h"
#import "SBITradingUtility.h"


@interface TTTradeViewController ()
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *limitButton;
@property (weak, nonatomic) IBOutlet UIButton *intraDayButton;
@property (weak, nonatomic) IBOutlet UIButton *dayButton;
@property(nonatomic,strong)NSString *currentSymbol;
@property(nonatomic,assign)EExchangeType currentExchangeType;
@property(nonatomic,strong)UINavigationController *tradeViewNavigationController;
@end

@implementation TTTradeViewController
@synthesize tradeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGlobalSymbolData) name:@"UpdateGlobalSymbol" object:nil];
    TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];

    self.currentSymbol = symbolDetails.symbolData.tradeSymbolName;
    
    if(self.currentSymbol){
        TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
        [diffusionHandler subscribe:symbolDetails.symbolData.subscriptionKey withContext:self];
        self.companyNameLabel.text = symbolDetails.symbolData.companyName;
        self.symbolNameLabel.text = self.currentSymbol;
    }
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"TradeTitleBar"];

    //set up the button title ...
    
    [_dayButton setTitle:NSLocalizedStringFromTable(@"Dur_Day", @"Localizable", @"Day") forState:UIControlStateNormal];
    [_intraDayButton setTitle:NSLocalizedStringFromTable(@"Intraday_Prod_Type", @"Localizable", @"IntraDay") forState:UIControlStateNormal];
    [_buyButton setTitle:NSLocalizedStringFromTable(@"Buy_Type", @"Localizable", @"Buy") forState:UIControlStateNormal];
    [_limitButton setTitle:NSLocalizedStringFromTable(@"Limit_Order_Title", @"Localizable", @"Limit") forState:UIControlStateNormal];
    
    _dayButton.titleLabel.font = _intraDayButton.titleLabel.font = _buyButton.titleLabel.font = _limitButton.titleLabel.font = SEMI_BOLD_FONT_SIZE(14.0);
    
    _companyNameLabel.font = _symbolNameLabel.font = SEMI_BOLD_FONT_SIZE(12.0);
    
    _bidValueLabel.font = _askValueLabel.font = _highValueLabel.font = _lowValueLabel.font = SEMI_BOLD_FONT_SIZE(12.0);
    
    _volumeLabel.font = _bidLabel.font = _askLabel.font = _lowLabel.font = _highLabel.font = SEMI_BOLD_FONT_SIZE(12.0);
    _ltpLabel.font = SEMI_BOLD_FONT_SIZE(16.0);
    _changeLabel.font = _percentageChangeLabel.font = SEMI_BOLD_FONT_SIZE(15.0);
    _acountNumberLabel.font = _acountNumberValueLabel.font = _orderTicketLabel.font = SEMI_BOLD_FONT_SIZE(13.0);
    _companyNameLabel.font = _symbolNameLabel.font = SEMI_BOLD_FONT_SIZE(13.0);
    
       // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated
{
    // set all labels to its localized names
    _tradeTitleLabel.text=NSLocalizedStringFromTable(@"Trade_Title", @"Localizable", @"Trade");
    _askLabel.text=NSLocalizedStringFromTable(@"Ask", @"Localizable", @"Ask");
    _bidLabel.text=NSLocalizedStringFromTable(@"Bid", @"Localizable", @"Bid");
    _highLabel.text=NSLocalizedStringFromTable(@"High", @"Localizable", @"High");
    _lowLabel.text=NSLocalizedStringFromTable(@"Low", @"Localizable", @"Low");
    _acountNumberLabel.text=NSLocalizedStringFromTable(@"Account_Number", @"Localizable", @"Account Number");
    _orderTicketLabel.text=NSLocalizedStringFromTable(@"Order_Ticket", @"Localizable", @"Order Ticket");
    
    //set the font
    
    _tradeTitleLabel.font = SEMI_BOLD_FONT_SIZE(19.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showEnlargedView:(id)sender{
    self.tradePopOver = [[TTTradePopoverController alloc] initWithNibName:@"TTTradePopoverController" bundle:nil];
    self.tradeViewNavigationController = [[UINavigationController alloc] initWithRootViewController:self.tradePopOver];
    self.tradePopOver.isModifyMode = NO;
    self.tradeViewNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:self.tradeViewNavigationController  animated:YES completion:^{
        //[self.tradeViewNavigationController view];
    }];
}

//-(IBAction)showEnlargedView:(id)sender{
//    isEnlargedView = YES;
//    NSLog(@"navigation %@",self.navigationController);
//    [self.pr AccountViewControllerShouldPresentinEnlargedView:self.navigationController];
//}

#pragma NSNotification handler

-(void)updateGlobalSymbolData{
    TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    
    self.currentSymbol = symbolDetails.symbolData.tradeSymbolName;
    
    if(self.currentSymbol){
        TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
         [diffusionHandler subscribe:symbolDetails.symbolData.subscriptionKey withContext:self];
        self.companyNameLabel.text = symbolDetails.symbolData.companyName;
        self.symbolNameLabel.text = self.currentSymbol;
    }
}

#pragma Diffusion Delegates

-(void)onDelta:(DFTopicMessage *)message{
    
    //find the row to be updated...
    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
    TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
    diffusionData = [diffusionData updateDiffusionDataWith:parsedArray];
      [self updateUI:diffusionData];
}

-(void)updateUI:(TTDiffusionData *) diffusionData{
    self.volumeLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.volume] ;
    self.ltpLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.lastSalePrice];
    self.changeLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.netPriceChange];
    if([diffusionData.netPriceChangeIndicator isEqualToString:@""])
        diffusionData.netPriceChangeIndicator = GET_SIGN_INDICATOR(diffusionData.netPriceChange);
    [self updateLabelBasedOnPriceIndicator:diffusionData.netPriceChangeIndicator];
    
    float percentage = 0.00;
    float priceChange = diffusionData.lastSalePrice-diffusionData.closingPrice;
    if(diffusionData.closingPrice != 0)
        percentage = (fabsf(priceChange)/diffusionData.closingPrice)*100;
    if(isnan(percentage)){
        percentage = 0.00;
    }
    
    
    self.percentageChangeLabel.text = [NSString stringWithFormat:@"%@%.02f %%",diffusionData.netPriceChangeIndicator,fabsf(percentage)];
    self.bidValueLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.bidValue];
    self.askValueLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.askValue];
    self.highValueLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.highPrice];
    self.lowValueLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.lowPrice];
}

-(void)updateLabelBasedOnPriceIndicator:(NSString *)inPriceIndicator{
    UIColor *color;
    if([inPriceIndicator isEqualToString:@"+"])
        color= SYMBOL_PROFIT_LABEL_COLOR;
    else
        color= SYMBOL_LOSS_LABEL_COLOR;
    
    self.ltpLabel.textColor = self.changeLabel.textColor = self.percentageChangeLabel.textColor = color;
    
}

@end
