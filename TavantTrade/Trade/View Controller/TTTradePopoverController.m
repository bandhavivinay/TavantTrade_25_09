//
//  TTTradePopoverController.m
//  TavantTrade
//
//  Created by TAVANT on 1/22/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTTradePopoverController.h"
#import "TTSymbolDetails.h"
#import "TTDiffusionData.h"
#import "SBITradingUtility.h"
#import "TTDismissingView.h"
#import "TTQuotesViewController.h"
#import "TTChartViewController.h"
#import "TTWatchlistEntryViewController.h"
#import "UINavigationController+KeyboardDismiss.h"
#import "TTAlertView.h"
#import "TTWidgetsViewController.h"
#import "TTAppDelegate.h"
#import "TTDashboardViewController.h"

#define kOFFSET_FOR_KEYBOARD 88.0
#define kQuantityFrame CGRectMake(10.0, 289.0,408.0, 30.0)
#define kDisclosedQuantityFrame CGRectMake(10.0, 337.0,408.0, 30.0)
#define kPriceFrame CGRectMake(10.0, 385.0,408.0, 30.0)
#define kTriggeredPriceFrame CGRectMake(10.0, 433.0,408.0, 30.0)
#define kKeyboardOffset1 270
#define kKeyboardOffset2 220

@interface TTTradePopoverController ()
@property (nonatomic, weak) IBOutlet UIView *enlargedHeaderView;
@property(nonatomic,strong)TTSymbolData *currentSymbol;
@property(nonatomic,strong)UIPopoverController *selectPopoverController;
@property(nonatomic,strong)NSMutableArray *optionsArray;
@property(nonatomic, strong) UIViewController* tradeOptionsListController;
@property(nonatomic, strong) NSString* subKey;
@property(nonatomic,weak)IBOutlet UIButton *chartButton;
@property(nonatomic,weak)IBOutlet UIButton *quotesButton;
@property(nonatomic,weak)IBOutlet UIButton *addToWatchlistButton;
@property(nonatomic,assign)UITextField *currentOnFocusTextField;
@property(nonatomic,assign)float originalScrollerOffsetY;
@property(nonatomic,weak)IBOutlet UILabel *exchangeTypeLabel;
@property (strong, nonatomic) IBOutlet UIView *priceBaseView;
@property (strong, nonatomic) IBOutlet UIView *triggerPriceBaseView;
@property (strong, nonatomic) IBOutlet UIView *quantityBaseView;
@property (strong, nonatomic) IBOutlet UIView *disclosedQuantityBaseView;
@end

@implementation TTTradePopoverController

@synthesize tradeOptionsListController = _tradeOptionsListController;
@synthesize popOverView = _popOverView;
@synthesize optionsArray = _optionsArray;
@synthesize durationType = _durationType;
@synthesize transactionType = _transactionType;
@synthesize selectedTradingOptionType = _selectedTradingOptionType;
@synthesize productType = _productType;
@synthesize orderType = _orderType;
@synthesize tradeDataSource = _tradeDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _optionsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.shouldShowBackButton){
        [self.cancelButton setTitle:self.previousScreenTitle forState:UIControlStateNormal];
        [self.cancelButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [self.cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-12,0,0)];
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
    }
    self.navigationController.navigationBarHidden = YES;
    _mainScroller.contentSize = CGSizeMake(_mainScroller.frame.size.width, _mainScroller.frame.size.height+150);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _enlargedHeaderView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"TradeTitleBar"];
    
    
    _tradeTitleLabel.text=NSLocalizedStringFromTable(@"Trade_Title", @"Localizable", @"Trade");
    _askLabel.text=NSLocalizedStringFromTable(@"Ask", @"Localizable", @"Ask");
    _bidLabel.text=NSLocalizedStringFromTable(@"Bid", @"Localizable", @"Bid");
    _highLabel.text=NSLocalizedStringFromTable(@"High", @"Localizable", @"High");
    _lowLabel.text=NSLocalizedStringFromTable(@"Low", @"Localizable", @"Low");
    _accNumberLabel.text=NSLocalizedStringFromTable(@"Account_Number", @"Localizable", @"Account Number");
    _orderTicketLabel.text=NSLocalizedStringFromTable(@"Order_Ticket", @"Localizable", @"Order Ticket");
    _quantityLabel.text=NSLocalizedStringFromTable(@"Qty", @"Localizable", @"Quantity");
    _disclosedQtyLabel.text=NSLocalizedStringFromTable(@"Dis_Qty", @"Localizable", @"Quantity");
    _triggeredPriceLabel.text=NSLocalizedStringFromTable(@"Trigger_Price", @"Localizable", @"Quantity");
    _priceLabel.text=NSLocalizedStringFromTable(@"Price", @"Localizable", @"Quantity");
    [_chartButton setTitle: NSLocalizedStringFromTable(@"Chart_Button_Title", @"Localizable", @"Chart") forState:UIControlStateNormal];
    _chartButton.titleLabel.font=REGULAR_FONT_SIZE(14);
    _quotesButton.titleLabel.font=REGULAR_FONT_SIZE(14);
    _addToWatchlistButton.titleLabel.font=REGULAR_FONT_SIZE(14);
    [_quotesButton setTitle: NSLocalizedStringFromTable(@"Quote_Button_Title", @"Localizable", @"Quotes") forState:UIControlStateNormal];
    [_addToWatchlistButton setTitle: NSLocalizedStringFromTable(@"Add_To_WatchList", @"Localizable", @"Add To Watchlist") forState:UIControlStateNormal];
    [_transactionTypeButton setTitle:NSLocalizedStringFromTable(@"Buy_Type", @"Localizable", @"Buy") forState:UIControlStateNormal];
    [_orderTypeButton setTitle:NSLocalizedStringFromTable(@"Intraday_Prod_Type", @"Localizable", @"IntraDay") forState:UIControlStateNormal];
    [_durationButton setTitle:NSLocalizedStringFromTable(@"Dur_Day", @"Localizable", @"Day") forState:UIControlStateNormal];
    [_productTypeButton setTitle:NSLocalizedStringFromTable(@"Limit_Order_Title", @"Localizable", @"Limit") forState:UIControlStateNormal];
    
    _companyNameLabel.font = _symbolNameLabel.font = _orderTicketLabel.font = _accNumberLabel.font = _accountNumberLabel.font = SEMI_BOLD_FONT_SIZE(14.0);
    _bidValueLabel.font = _askValueLabel.font = _highValueLabel.font = _lowValueLabel.font = _bidLabel.font = _askLabel.font = _highLabel.font = _lowLabel.font = SEMI_BOLD_FONT_SIZE(13.0);
    
    _transactionTypeButton.titleLabel.font = _orderTypeButton.titleLabel.font = _durationButton.titleLabel.font = _productTypeButton.titleLabel.font = SEMI_BOLD_FONT_SIZE(17.0);
    
    _symbolNameLabel.font = _companyNameLabel.font = SEMI_BOLD_FONT_SIZE(14.0);
    
    _tradeTitleLabel.font = SEMI_BOLD_FONT_SIZE(22.0);
    
    self.cancelButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);
    
    _quantityLabel.font = _disclosedQtyLabel.font = _triggeredPriceLabel.font = _priceLabel.font = _txtDisclosedQuantity.font = _txtPrice.font = _txtQuantity.font = _txtTriggeredPrice.font = SEMI_BOLD_FONT_SIZE(15.0);
    
    if(self.isModifyMode){
        self.transactionTypeButton.enabled = NO;
        self.subKey = _tradeDataSource.subscriptionKey;
        self.currentSymbol = _tradeDataSource.symbolData;
        if(_tradeDataSource.transactionType)
            self.transactionType = ([_tradeDataSource.transactionType caseInsensitiveCompare:@"Buy"]==NSOrderedSame)?eBuy:eSell;
        if(_tradeDataSource.productType)
            self.productType = ([_tradeDataSource.productType caseInsensitiveCompare:@"Intraday"] == NSOrderedSame)?eIntraday:eDelivery;
        if(_tradeDataSource.priceType)
            self.orderType = [SBITradingUtility returnOrderType:_tradeDataSource.priceType];
        if(_tradeDataSource.orderDuration)
            self.durationType = ([_tradeDataSource.orderDuration caseInsensitiveCompare:@"Day"]==NSOrderedSame)?eDay:eIOC;
        
        //hide the buttons ...
        
        self.chartButton.hidden = YES;
        self.quotesButton.hidden = YES;
        self.addToWatchlistButton.hidden = YES;
        
        _txtTriggeredPrice.text = [NSString stringWithFormat:@"%f",_tradeDataSource.triggeredPrice];
        _txtPrice.text = [NSString stringWithFormat:@"%.2f",_tradeDataSource.priceToFill];
        _txtQuantity.text = [NSString stringWithFormat:@"%d",_tradeDataSource.quantitytoFill];
        _txtDisclosedQuantity.text = [NSString stringWithFormat:@"%d",_tradeDataSource.disclosedQuantity];
        
        //NSLog(@"%@ ..... %@ ..... %@ .... %@",_tradeDataSource.pr)
        
    }
    else{
        _tradeDataSource= nil;
        self.transactionTypeButton.enabled = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGlobalSymbolData) name:@"UpdateGlobalSymbol" object:nil];
        TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
        self.subKey=symbolDetails.symbolData.subscriptionKey;
        //        _mainScroller.contentSize = CGSizeMake(428, 600);
        self.currentSymbol = symbolDetails.symbolData;
        self.companyNameLabel.text = symbolDetails.symbolData.companyName;
        self.transactionType = eBuy;
        self.productType = eIntraday;
        self.orderType = eLimitType;
        self.durationType = eDay;
        
        self.chartButton.hidden = NO;
        self.quotesButton.hidden = NO;
        self.addToWatchlistButton.hidden = NO;
        
        _txtTriggeredPrice.text = @"";
        _txtPrice.text = @"";
        _txtQuantity.text = @"";
        _txtDisclosedQuantity.text = @"";
        
    }
    NSLog(@"%@",self.subKey);
    if(self.currentSymbol){
        TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
        if(![self.subKey isEqual:[NSNull null]])
            [diffusionHandler subscribe:self.subKey withContext:self];
        self.symbolNameLabel.text = self.currentSymbol.tradeSymbolName;
        self.exchangeTypeLabel.text = self.currentSymbol.exchange;
    }
    
    self.listingTableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.listingTableView.layer.borderWidth = 0.5;
    self.listingTableView.layer.cornerRadius = 2.0;
    
    
    
    /************/
    NSArray *textFiledViewsSet ;//=  [NSArray arrayWithObjects:self.quantityBaseView,self.disclosedQuantityBaseView,self.priceBaseView,self.triggerPriceBaseView, nil];
    
        if (![self.currentSymbol.series isEqualToString: @"EQ"]) {
            textFiledViewsSet =  [NSArray arrayWithObjects:self.quantityBaseView,self.priceBaseView, nil];
        }
        else {
            textFiledViewsSet =  [NSArray arrayWithObjects:self.quantityBaseView,self.disclosedQuantityBaseView,self.priceBaseView, nil];
     }
    
    [self addTextFiledsViews:textFiledViewsSet];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    //    self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
    self.navigationController.view.bounds = CGRectMake(0, 0, 428, 506);
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.view.superview.backgroundColor = [UIColor clearColor];
}

-(void)updateUI:(TTDiffusionData *) diffusionData{
    self.volumeLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.volume] ;
    self.ltpLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.lastSalePrice];
    self.changeLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.netPriceChange];
    float percentage = 0.00;
    float priceChange = diffusionData.lastSalePrice-diffusionData.closingPrice;
    if(diffusionData.closingPrice != 0)
        percentage = (fabsf(priceChange)/diffusionData.closingPrice)*100;
    if(isnan(percentage)){
        percentage = 0.00;
    }
    
    if([diffusionData.netPriceChangeIndicator isEqualToString:@""])
        diffusionData.netPriceChangeIndicator = GET_SIGN_INDICATOR(diffusionData.netPriceChange);
    [self updateLabelBasedOnPriceIndicator:diffusionData.netPriceChangeIndicator];
    
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


-(void)setOrderType:(EOrderType)orderType
{
    _orderType  = orderType;
    [_orderTypeButton setTitle:[SBITradingUtility getTitleForOrderType:_orderType] forState:UIControlStateNormal];
    [self updateTradeOptionsUI];
}

-(void)setTransactionType:(ETransactionType)transactionType
{
    _transactionType = transactionType;
    [_transactionTypeButton setTitle:[SBITradingUtility getTitleForTransactionType:_transactionType] forState:UIControlStateNormal];
}

-(void)setDurationType:(EDuration)durationType
{
    _durationType =  durationType;
    [_durationButton setTitle:[SBITradingUtility getTitleForDuration:_durationType] forState:UIControlStateNormal];
}

-(void)setProductType:(EProductType)productType
{
    _productType = productType;
    [_productTypeButton setTitle:[SBITradingUtility getTitleForProductType:_productType] forState:UIControlStateNormal];
}

- (void) updateTradeOptionsUI
{
    //    _txtQuantity.superview.frame = kQuantityFrame;
    //    _txtDisclosedQuantity.superview.frame = kDisclosedQuantityFrame;
    //    _txtPrice.superview.frame = kPriceFrame;
    //    _txtTriggeredPrice.superview.frame = kTriggeredPriceFrame;
    //    _txtQuantity.superview.hidden = NO;
    //    _txtDisclosedQuantity.superview.hidden = NO;
    //    _txtPrice.superview.hidden = NO;
    //    _txtTriggeredPrice.superview.hidden = NO;
    NSMutableArray *textFiledViewsArray = [[NSMutableArray alloc] init];
    switch (_orderType) {
            
        case eLimitType:
        {
            [self removeAllTextFieldViews];
            [textFiledViewsArray addObjectsFromArray:[NSArray arrayWithObjects:self.quantityBaseView,self.priceBaseView, nil]];
        }
            break;
            
        case eMarketType:
        {

            [self removeAllTextFieldViews];
            [textFiledViewsArray addObjectsFromArray:[NSArray arrayWithObjects:self.quantityBaseView, nil]];
        }
            break;
        case eSLLType:
        {
            [self removeAllTextFieldViews];
            [textFiledViewsArray addObjectsFromArray:[NSArray arrayWithObjects:self.quantityBaseView,self.priceBaseView,self.triggerPriceBaseView, nil]];
        }
            break;
        case eSLMType:
        {
            [self removeAllTextFieldViews];
            [textFiledViewsArray addObjectsFromArray:[NSArray arrayWithObjects:self.quantityBaseView,self.triggerPriceBaseView, nil]];
            
        }
            break;
            
        default:
            break;
    }
    
    if([self.currentSymbol.series isEqualToString:@"EQ"]){
//        [textFiledViewsArray addObject:self.disclosedQuantityBaseView];
        [textFiledViewsArray insertObject:self.disclosedQuantityBaseView atIndex:1];
    }
    [self addTextFiledsViews:textFiledViewsArray];
    
}

#pragma mark- UI supporters


-(void)removeAllTextFieldViews {
    //    [self.quantityBaseView removeFromSuperview];
    //    [self.disclosedQuantityBaseView removeFromSuperview];
    //    [self.triggerPriceBaseView removeFromSuperview];
    //    [self.priceBaseView removeFromSuperview];
    
    [self.quantityBaseView setHidden:YES];
    [self.disclosedQuantityBaseView setHidden:YES];
    [self.triggerPriceBaseView setHidden:YES];
    [self.priceBaseView setHidden:YES];
}

-(void)addTextFiledsViews:(NSArray *)viewsSet {
    
    CGFloat xoffset = 10.0;
    CGFloat yoffset = 291.0;
    
    for(UIView *tmpView in viewsSet) {
        
        tmpView.frame = CGRectMake(xoffset, yoffset, tmpView.frame.size.width, tmpView.frame.size.height);
        NSLog(@"Y Offset %f",yoffset);
        NSLog(@"textfirld frames %@",NSStringFromCGRect(tmpView.frame));
        yoffset = tmpView.frame.size.height + yoffset +10;
        if (![tmpView isDescendantOfView:self.mainScroller]) {
            [self.mainScroller addSubview:tmpView];
        }
        // [self.view addSubview:tmpView];
        [tmpView setHidden:NO];
    }
}

#pragma mark-
#pragma mark UIKeyboard Notification methods ...

-(void)onKeyboardShow:(NSNotification *)notification{
    NSLog(@"Keyboard shown");
    
    //TODO:Bandhavi
    
    //Lets get the keyboard height ...
    NSDictionary *keyboardInfo = [notification userInfo];
    CGSize keyboardFrame = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    float keyboardHeight = keyboardFrame.width;
    
    float scrollPointY = 0;
    
    if (_orderType==eSLLType) {
        scrollPointY = keyboardHeight - kKeyboardOffset2;
    }
    else {
        scrollPointY = keyboardHeight - kKeyboardOffset1;
    }
    
    CGRect viewableArea = CGRectMake(0, 0, self.view.frame.size.width, scrollPointY);
    CGRect textFieldFrame = self.currentOnFocusTextField.superview.frame;
    NSLog(@"trigger %@ %@",_txtTriggeredPrice,_txtTriggeredPrice.superview);
    
    if (!CGRectContainsRect(viewableArea, textFieldFrame)) {
        
        self.originalScrollerOffsetY = _mainScroller.contentOffset.y;
        
        [UIView animateWithDuration:0.1 animations:^{
            
            [_mainScroller setContentOffset:CGPointMake(0.0, scrollPointY)];
        } completion:^(BOOL finished) {
            if (_orderType==eSLMType) {
                // self.triggerPriceBaseView.frame = kPriceFrame;
            }
        }];
        
    }
    
}

-(void)onKeyboardHide:(NSNotification *)notification{
    NSLog(@"Keyboard hidden");
    
    [UIView animateWithDuration:0.1 animations:^{
        
        [_mainScroller setContentOffset:CGPointMake(0, self.originalScrollerOffsetY)];
    } completion:^(BOOL finished){
        if (_orderType==eSLMType) {
            // self.triggerPriceBaseView.frame = kPriceFrame;
        }
    }];
    
    //    if (_orderType==eSLMType) {
    //        _txtPrice.superview.hidden = YES;
    //       // _txtTriggeredPrice.superview.frame = kPriceFrame;
    //        //[self.view layoutIfNeeded];
    //    }
    //    [self updateTradeOptionsUI];
}


#pragma NSNotification handler

-(void)updateGlobalSymbolData{
    TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    self.currentSymbol = symbolDetails.symbolData;
    if(self.currentSymbol){
        TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
        [diffusionHandler subscribe:symbolDetails.symbolData.subscriptionKey withContext:self];
        self.companyNameLabel.text = symbolDetails.symbolData.companyName;
        self.symbolNameLabel.text = self.currentSymbol.tradeSymbolName;
        self.exchangeTypeLabel.text = self.currentSymbol.exchange;
    }
}

#pragma NSNotification handler

-(void)onDelta:(DFTopicMessage *)message{
    
    //find the row to be updated...
    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
    TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
    diffusionData = [diffusionData updateDiffusionDataWith:parsedArray];
    [self updateUI:diffusionData];
    
}

- (IBAction)closeTradeView:(id)sender {
    
    NSLog(@"Trade Close tried");

    if(!self.shouldShowBackButton)
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"Trade Closed");
        }];
    else{
        //        self.navigationController.view.center = CGPointMake(435, 359);
        //        self.navigationController.view.bounds = CGRectMake(0, 0, 428, 506);
        self.navigationController.view.bounds = self.previousScreenFrame;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onTransactionTypeClick:(id)sender {
    [self closeKeyBoard];
    _selectedTradingOptionType = [sender tag];
    [_optionsArray removeAllObjects];
    [self.optionsArray addObject:[SBITradingUtility getTitleForTransactionType:eBuy]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForTransactionType:eSell]];
    [self showTradeOptionsListinFrame:[(UIButton *)sender frame]];
    
}

- (IBAction)onproductTypeclick:(id)sender {
    [self closeKeyBoard];
    _selectedTradingOptionType = [sender tag];
    [_optionsArray removeAllObjects];
    [self.optionsArray addObject:[SBITradingUtility getTitleForProductType:eIntraday]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForProductType:eDelivery]];
    [self showTradeOptionsListinFrame:[(UIButton *)sender frame]];
    
}

- (IBAction)onDurationCLick:(id)sender {
    [self closeKeyBoard];
    _selectedTradingOptionType = [sender tag];
    [_optionsArray removeAllObjects];
    [self.optionsArray addObject:[SBITradingUtility getTitleForDuration:eDay]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForDuration:eIOC]];
    [self showTradeOptionsListinFrame:[(UIButton *)sender frame]];
    
}


- (IBAction)onOrderTypeClick:(id)sender {
    [self closeKeyBoard];
    _selectedTradingOptionType = [sender tag];
    [_optionsArray removeAllObjects];
    [self.optionsArray addObject:[SBITradingUtility getTitleForOrderType:eLimitType]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForOrderType:eMarketType]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForOrderType:eSLLType]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForOrderType:eSLMType]];
    [self showTradeOptionsListinFrame:[(UIButton *)sender frame]];
    
}

- (IBAction)openPreviewPage:(id)sender {
    [self closeKeyBoard];
    if([self validateTExtFields] && [self validateOrderValues]){
        self.tradepreview=[[TTTradePreviewController alloc] initWithNibName:@"TTTradePreviewController" bundle:nil];
        self.tradepreview.isModifyMode = self.isModifyMode;
        _tradepreview.delegate = self;
        self.tradepreview.currentSelectedOrder = _tradeDataSource;
        [self setValuesforPreview: self.tradepreview];
        [self.navigationController pushViewController:self.tradepreview animated:YES];
        //        self.tradepreview.modalPresentationStyle = UIModalPresentationFormSheet;
        //        [self presentViewController:self.tradepreview animated:NO completion:NULL];
    }
    //    else{
    //        NSString *msg=@"Please Enter mandatory fields to preview the page";
    //        [self showAlert:msg];
    //    }
    
}
// common alert for the page
-(void) showAlert: (NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Details"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)setValuesforPreview:(TTTradePreviewController *)preview{
    NSLog(@"text is %@",self.txtQuantity.text);
    preview.qty = self.txtQuantity.text;
    preview.orderType =[SBITradingUtility getTitleForOrderType:self.orderType];
    preview.validity=[SBITradingUtility getTitleForDuration:self.durationType];
    preview.prodType=[SBITradingUtility getTitleForProductType:self.productType];
    preview.disQty= self.txtDisclosedQuantity.text;
    preview.company=self.currentSymbol.companyName;
    preview.symbolData=self.currentSymbol;
    
    preview.subscriptionKey=self.subKey;
    preview.tradeType=[SBITradingUtility getTitleForTransactionType:self.transactionType];
    preview.price=self.txtPrice.text;
    if(![self.triggeredPriceLabel.text isEqualToString:@""])
        preview.triggerPrice=self.txtTriggeredPrice.text;
    else
        preview.triggerPrice = @"NA";
    
}
//To Do: dont allow user to open preview without entering values
-(BOOL)validateTExtFields{
    BOOL isValid=TRUE;
    switch(self.orderType){
            
        case 0:if([self.txtQuantity.text isEqualToString:@""]||[self.txtPrice.text isEqualToString:@""]){
            isValid=FALSE;
        }
            break;
        case 1:if([self.txtQuantity.text isEqualToString:@""]){
            isValid=FALSE;
        }
            break;
        case 2:if([self.txtQuantity.text isEqualToString:@""]||[self.txtPrice.text isEqualToString:@""]||[self.txtTriggeredPrice.text isEqualToString:@""]){
            isValid=FALSE;
        }
            break;
        case 3:if([self.txtQuantity.text isEqualToString:@""]||[self.txtTriggeredPrice.text isEqualToString:@""]){
            isValid=FALSE;
        }
            break;
            
    }
    if(!isValid){
        NSString *msg=@"Please Enter mandatory fields to preview the page";
        [self showAlert:msg];
    }
    return isValid;
}

-(BOOL)validateOrderValues{
    
    //check for disclosed quantity ...
    if(![self.txtDisclosedQuantity.text isEqualToString:@""]){
        int qty = [self.txtQuantity.text intValue];
        int disclosedQty = [self.txtDisclosedQuantity.text intValue];
        if(disclosedQty > qty){
            [self showAlert:@"Disclosed quantity cant be greater than quantity"];
            return NO;
        }
        else if(disclosedQty < 0.1*qty){
            [self showAlert:@"Disclosed quantity cant be lesser than 10% of order quantity"];
            return NO;
        }
    }
    
    
    if(self.orderType == eSLLType){
        float triggeredPrice = [self.txtTriggeredPrice.text floatValue];
        float limitPrice = [self.txtPrice.text floatValue];
        if(self.transactionType == eBuy){
            if(triggeredPrice >= limitPrice){
                [self showAlert:@"For Buy Orders,Trigger Price should be less than the Limit Price"];
                return NO;
            }
        }
        else{
            if(triggeredPrice <= limitPrice){
                [self showAlert:@"For Sell Orders,Trigger Price should be greater than the Limit Price"];
                return NO;
            }
        }
    }
    return YES;
    
}

-(void) closeKeyBoard{
    
    //    if ([self.currentOnFocusTextField isFirstResponder]) {
    //        NSLog(@"YESSSSSSSSS");
    //    }
    //    else {
    //        NSLog(@"NOOOOOOOOO");
    //    }
    
    [self.currentOnFocusTextField resignFirstResponder];
    
}

-(void)showTradeOptionsListinFrame:(CGRect)inFrame
{
    [self.listingTableView reloadData];
    if(!_tradeOptionsListController)
    {
        _tradeOptionsListController = [[UIViewController alloc] init];
    }
    _tradeOptionsListController.view = _popOverView;
    
    if (self.optionsArray.count < 3) {
        CGRect tmpFrame = self.popOverView.frame;
        tmpFrame.size.height = 100;
        self.popOverView.frame = tmpFrame;
    }
    else {
        CGRect tmpFrame = self.popOverView.frame;
        tmpFrame.size.height = 145;
        self.popOverView.frame = tmpFrame;
    }
    self.selectPopoverController = [[UIPopoverController alloc] initWithContentViewController:_tradeOptionsListController];
    [self.selectPopoverController setPopoverContentSize:CGSizeMake(self.popOverView.frame.size.width, self.popOverView.frame.size.height)];
    [self.selectPopoverController presentPopoverFromRect:inFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

#pragma TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.optionsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.optionsArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_selectedTradingOptionType)
    {
        case eTransaction:
        {
            self.transactionType = indexPath.row;
        }
            break;
        case eProduct:
        {
            self.productType = indexPath.row;
        }
            break;
        case eOrder:
        {
            self.orderType = indexPath.row;
            [self clearTextFields];
        }
            break;
        case eDuration:
        {
            self.durationType = indexPath.row;
        }
            break;
            
        default:
            break;
    }
    
    [_selectPopoverController dismissPopoverAnimated:YES];
}

-(void)clearTextFields{
    self.txtTriggeredPrice.text=@"";
    self.txtQuantity.text=@"";
    self.txtPrice.text=@"";
    self.txtDisclosedQuantity.text=@"";
}

#pragma mark - UITextfield Delegate Method
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string length]==0){
        return YES;
    }
    
    /*  limit to only numeric characters  */
    NSCharacterSet* numberCharSet;
    if(textField == _txtPrice || textField == _txtTriggeredPrice){
        numberCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    }
    else{
        numberCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    
    
    for (int i = 0; i < [string length]; ++i)
    {
        unichar c = [string characterAtIndex:i];
        if (![numberCharSet characterIsMember:c])
        {
            return NO;
        }
    }
    
    if (textField == self.txtPrice || textField == self.txtTriggeredPrice){
        NSLog(@"here");
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSString *expression = @"^[^.]([0-9]{1,2})*(\\.([0-9]{1,2})?)?$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches==0){
            return NO;
        }
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    //Keyboard becomes visible
    self.currentOnFocusTextField = textField;
    //resize
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    //keyboard will hide
    //    self.view.bounds = CGRectMake( self.view.frame.origin.x,
    //                                 self.view.frame.origin.y-80,
    //                                 self.view.frame.size.width,
    //                                 self.view.frame.size.height ); //resize
}

-(IBAction)goToQuotes:(id)sender{
    
    for(id viewController in self.navigationController.viewControllers){
        if([viewController isKindOfClass:[TTQuotesViewController class]]){
            //            self.navigationController.view.center = CGPointMake(435, 359);
            self.navigationController.view.bounds = self.previousScreenFrame;
            
            //            self.navigationController.view.frame = self.previousScreenFrame;
            //            self.navigationController.view.center = CGPointMake(512, 350);
            
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    //the Quotes screen is not presented yet ...
    TTQuotesViewController *quotesViewController = [[TTQuotesViewController alloc] initWithNibName:@"TTQuotesViewController" bundle:nil];
    quotesViewController.previousScreenTitle = @"Trade";
    quotesViewController.previousScreenFrame = self.view.frame;
    quotesViewController.shouldShowBackButton = YES;
    [self.navigationController pushViewController:quotesViewController animated:YES];
    
}

-(IBAction)goToChart:(id)sender{
    for(id viewController in self.navigationController.viewControllers){
        if([viewController isKindOfClass:[TTChartViewController class]]){
            //            self.navigationController.view.center = CGPointMake(435, 359);
            //            self.navigationController.view.frame = self.previousScreenFrame;
            //            self.navigationController.view.center = CGPointMake(512, 350);
            self.navigationController.view.bounds = self.previousScreenFrame;
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    //the Quotes screen is not presented yet ...
    TTChartViewController *chartViewController = [[TTChartViewController alloc] initWithNibName:@"TTChartViewController" bundle:nil];
    chartViewController.previousScreenTitle = @"Trade";
    chartViewController.previousScreenFrame = self.view.frame;
    chartViewController.shouldShowBackButton = YES;
    self.navigationController.view.frame = chartViewController.view.frame;
    [self.navigationController pushViewController:chartViewController animated:YES];
}



-(IBAction)addToWatchlist:(id)sender{
    //show a list of watchlist to the user ...
    //show all watchlists...
    TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    TTWatchlistEntryViewController *watchListViewController = [[TTWatchlistEntryViewController alloc] initWithNibName:@"TTWatchlistEntryViewController" bundle:nil];
    SBITradingUtility *utilityObj = [SBITradingUtility sharedUtility];
    watchListViewController.loadWatchlistDelegate = utilityObj.watchlistController;
    
    watchListViewController.parentController = self;
    watchListViewController.isCalledFromOtherScreen = YES;
    watchListViewController.shouldShowBackButton=YES;
    watchListViewController.previousScreenTitle=@"Trade";
    watchListViewController.currentSymbol = symbolDetails.symbolData;
    NSLog(@"nav %@",self.navigationController);
    [self.navigationController pushViewController:watchListViewController animated:YES];
}


- (void)tradePreviewControllerDidPlaceTradeSuccessfully:(TTTradePreviewController *)inController shouldShowOrders:(BOOL)showOrder
{
    if ([[self.navigationController viewControllers] objectAtIndex:0] == self)
    {
        [self dismissViewControllerAnimated:NO completion:^{
        }];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(tradePopoverControllerDidPlaceTradeSuccessfully:shouldShowOrders:)])
    {
        [_delegate tradePopoverControllerDidPlaceTradeSuccessfully:self shouldShowOrders:showOrder];
    }
    else
    {
        if(showOrder)
            [self performSelector:@selector(showOrder) withObject:nil afterDelay:1];
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderBook" object:nil];
    }
    

}

-(void)showOrder
{
    dispatch_async(dispatch_get_main_queue(), ^{
        TTWidgetsViewController *widgetViewController = [(TTAppDelegate *)[[UIApplication sharedApplication] delegate] dashboardViewController].widgetsViewController;
        [widgetViewController showWidgetsofType:eOrdersMenuItem];
    });
}


@end
