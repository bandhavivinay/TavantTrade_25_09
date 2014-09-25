
//
//  TTQuotesViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 1/15/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTQuotesViewController.h"
#import "TTDiffusionData.h"
#import "SBITradingUtility.h"
#import "TTSymbolDetails.h"
#import "TTQuotesTableViewCell.h"
#import "TTDismissingView.h"
#import "TTChartViewController.h"
#import "TTWatchlistEntryViewController.h"
#import "TTConstants.h"
#import <QuartzCore/QuartzCore.h>
#import "TTAppDelegate.h"
#import "OrderedDictionary.h"
#import "TTAppDelegate.h"
#import "TTDashboardViewController.h"

@interface TTQuotesViewController ()
@property (nonatomic, weak) IBOutlet UIView *enlargedHeaderView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIView *symbolBackgroundView;
@property(nonatomic,weak)IBOutlet UILabel *lastTradePriceLabel;
@property(nonatomic,weak)IBOutlet UILabel *volumeValueLabel;
@property(nonatomic,weak)IBOutlet UILabel *priceChangeLabel;
@property(nonatomic,weak)IBOutlet UILabel *companynameLabel;
//@property(nonatomic,weak)IBOutlet UILabel *symbolNameLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetLastTradePriceLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetVolumeLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetPriceChangeLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetCompanynameLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetSymbolNameLabel;
@property(nonatomic,weak)IBOutlet UITableView *enlargedQuotesTableView;
@property(nonatomic,weak)IBOutlet UITableView *quotesTableView;
@property(nonatomic,strong)NSString *currentSymbol;
@property(nonatomic,strong)OrderedDictionary *dataSourceDict;
@property(nonatomic,assign)EExchangeType currentExchangeType;
@property(nonatomic,strong) UINavigationController *watchlistEntryNavigationController;
@property(nonatomic,weak)IBOutlet UIButton *symbolButton;
@property(nonatomic,weak)IBOutlet UIButton *showChartSnapshotButton;

@end

BOOL isEnlargedView = NO;

@implementation TTQuotesViewController

@synthesize dataSourceDict,watchlistEntryNavigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    self.view.superview.frame = CGRectMake(0, 0, 428, 506);
//    self.view.frame = CGRectMake(50, 50, 428, 506);
    self.navigationController.view.bounds = CGRectMake(0, 0, 428, 506);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _symbolBackgroundView.layer.cornerRadius = 4.0f;
    
    _companynameLabel.font = REGULAR_FONT_SIZE(17.0);
    
    _widgetCompanynameLabel.font = _widgetSymbolNameLabel.font = SEMI_BOLD_FONT_SIZE(13.0);
    
    _lastLabel.font = _changeLabel.font = _lastTradePriceLabel.font = _priceChangeLabel.font = _widgetLastTradePriceLabel.font = _widgetPriceChangeLabel.font = SEMI_BOLD_FONT_SIZE(15.0);
    
    
    
    _volumeValueLabel.font = _widgetVolumeLabel.font = REGULAR_FONT_SIZE(15.0);
    
    _lastWidgetLabel.font = _changeWidgetLabel.font = _volumeWidgetLabel.font =  REGULAR_FONT_SIZE(12.0);
    
    _quotesTitleLabel.text = _quotesWidgetlabel.text = NSLocalizedStringFromTable(@"Quote_Button_Title", @"Localizable", @"Quotes");
    _lastLabel.text = _lastWidgetLabel.text = NSLocalizedStringFromTable(@"Last", @"Localizable", @"Last");
    _changeLabel.text = _changeWidgetLabel.text = NSLocalizedStringFromTable(@"Change", @"Localizable", @"Change");
    _volumeLabel.text = _volumeWidgetLabel.text = NSLocalizedStringFromTable(@"Volume", @"Localizable", @"Volume");
    [_cancelButton setTitle:NSLocalizedStringFromTable(@"Cancel_Button_Title", @"Localizable", @"Cancel") forState:UIControlStateNormal];
    _symbolButton.titleLabel.font = REGULAR_FONT_SIZE(17.0);
//    [_addToWatchlistButton setTitle:NSLocalizedStringFromTable(@"Add_To_WatchList", @"Localizable", @"Add To WatchList") forState:UIControlStateNormal];
    
    //set the font
    _quotesTitleLabel.font = SEMI_BOLD_FONT_SIZE(22.0);
    _quotesWidgetlabel.font = SEMI_BOLD_FONT_SIZE(19.0);
     _cancelButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);
    
    _enlargedHeaderView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"QuotesTitleBar"];
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"QuotesTitleBar"];

//    self.navigationController.navigationBarHidden = YES;
    
    if(self.shouldShowBackButton){
        [self.cancelButton setTitle:self.previousScreenTitle forState:UIControlStateNormal];
        [self.cancelButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [self.cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-5,0,0)];
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateExchangeType:) name:@"UpdateExchangeType" object:nil];
    
    dataSourceDict = [[OrderedDictionary alloc] init];
    int i = 0;
    [dataSourceDict insertObject:@"0.00" forKey:@"Open" atIndex:i++];
    [dataSourceDict insertObject:@"0.00" forKey:@"Close" atIndex:i++];
    [dataSourceDict insertObject:@"0.00" forKey:@"High Price" atIndex:i++];
    [dataSourceDict insertObject:@"0.00" forKey:@"Low Price" atIndex:i++];
    [dataSourceDict insertObject:@"0.00" forKey:@"Best Bid" atIndex:i++];
    [dataSourceDict insertObject:@"0.00" forKey:@"Best Offer" atIndex:i++];
    [dataSourceDict insertObject:@"0.00" forKey:@"% Change" atIndex:i++];
    [dataSourceDict insertObject:@"NA" forKey:@"Last Traded Time" atIndex:i++];
    [dataSourceDict insertObject:@"NSE" forKey:@"Exchange" atIndex:i++];
    [dataSourceDict insertObject:@"0.00" forKey:@"52 Week High" atIndex:i++];
    [dataSourceDict insertObject:@"0.00" forKey:@"52 Week Low" atIndex:i++];
    
    
                      
//                      @"0.00",@"Open",@"0.00",@"Close",@"0.00",@"High",@"0.00",@"Low",@"+0.00%",@"% Change",@"0.00",@"NSE",@"Exchange",@"52 Week High",@"0.00",@"52 Week Low", nil];
//    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGlobalSymbolData) name:@"UpdateGlobalSymbol" object:nil];
    TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    
    self.currentSymbol = symbolDetails.symbolData.tradeSymbolName;
    
    if(self.currentSymbol){
        TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
        [diffusionHandler subscribe:symbolDetails.symbolData.subscriptionKey withContext:self];
        self.companynameLabel.text = symbolDetails.symbolData.companyName;
        [_symbolButton setTitle:self.currentSymbol forState:UIControlStateNormal];
        self.widgetCompanynameLabel.text = self.companynameLabel.text;
        self.widgetSymbolNameLabel.text = self.symbolButton.titleLabel.text;
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    TTAppDelegate *delegate = (TTAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(delegate.chartImage != nil)
        [_showChartSnapshotButton setBackgroundImage:delegate.chartImage forState:UIControlStateNormal];
    self.navigationController.view.superview.backgroundColor = [UIColor clearColor];
}

-(void)dismissView:(id)sender{
    isEnlargedView = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSourceDict count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TTQuotesTableViewCell *cell;
    
    if(tableView == self.enlargedQuotesTableView){
        static NSString *enlargedCellIdentifier = @"EnlargedCell";
        cell = [tableView dequeueReusableCellWithIdentifier:enlargedCellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTQuotesEnlargedTableViewCell" owner:self options:nil];
            
            for(id oneObject in nib) {
                
                if([oneObject isKindOfClass:[TTQuotesTableViewCell class]]) {
                    cell = (TTQuotesTableViewCell *)oneObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.leftTitleLabel.font = cell.valueLabel.font = LIGHT_FONT_SIZE(18.0);
                    
                }
                
            }
            
        }
    }
    else if(tableView == self.quotesTableView){
        static NSString *cellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTQuotesTableViewCell" owner:self options:nil];
            for(id oneObject in nib) {
                
                if([oneObject isKindOfClass:[TTQuotesTableViewCell class]]) {
                    cell = (TTQuotesTableViewCell *)oneObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.leftTitleLabel.font = cell.valueLabel.font = REGULAR_FONT_SIZE(14.0);
                }
                
            }
            
        }

    }
    
    //Configure the cell...
    
    NSString *key = [[dataSourceDict allKeys] objectAtIndex:indexPath.row];
    
    cell.leftTitleLabel.text = key;
    cell.valueLabel.text = [dataSourceDict valueForKey:key];
    
    if([key isEqualToString:@"% Change"]){
        //check for profit or loss to set the color of the label...
        if([cell.valueLabel.text rangeOfString:@"-"].location != NSNotFound)
            cell.valueLabel.textColor = SYMBOL_LOSS_LABEL_COLOR;
        else
            cell.valueLabel.textColor = SYMBOL_PROFIT_LABEL_COLOR;
    }
    
    return cell;
    
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Will Selected");
    return indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Selected");
}

-(void) dealloc
{
    NSLog(@"Quotes Dealloc called");
}

#pragma Diffusion Delegates

-(void)onDelta:(DFTopicMessage *)message{
    
    //find the row to be updated...
    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
    TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
    diffusionData = [diffusionData updateDiffusionDataWith:parsedArray];
    
    float priceChange = diffusionData.lastSalePrice-diffusionData.closingPrice;
    if([diffusionData.netPriceChangeIndicator isEqualToString:@""])
        diffusionData.netPriceChangeIndicator = GET_SIGN_INDICATOR(priceChange);
    [self updateLabelBasedOnPriceIndicator:diffusionData.netPriceChangeIndicator];
    float percentage = 0.00;
    if(diffusionData.closingPrice != 0)
        percentage = (fabsf(priceChange)/diffusionData.closingPrice)*100;
    if(isnan(percentage)){
        percentage = 0.00;
    }
    self.priceChangeLabel.text = [NSString stringWithFormat:@"%@%.02f(%@%.02f%%)",diffusionData.netPriceChangeIndicator,fabsf(priceChange),diffusionData.netPriceChangeIndicator,percentage];
    self.lastTradePriceLabel.text = [NSString stringWithFormat:@"%.02f",diffusionData.lastSalePrice];
    self.volumeValueLabel.text = [NSString stringWithFormat:@"%.02f M",diffusionData.volume];
    
    self.widgetVolumeLabel.text = self.volumeValueLabel.text;
    self.widgetPriceChangeLabel.text = self.priceChangeLabel.text;
    self.widgetLastTradePriceLabel.text = self.lastTradePriceLabel.text;
    
    //update the data source...
    
    [dataSourceDict setValue:[NSString stringWithFormat:@"%.02f",diffusionData.openingPrice] forKey:@"Open"];
    [dataSourceDict setValue:[NSString stringWithFormat:@"%.02f",diffusionData.closingPrice] forKey:@"Close"];
    [dataSourceDict setValue:[NSString stringWithFormat:@"%.02f",diffusionData.highPrice] forKey:@"High Price"];
    [dataSourceDict setValue:[NSString stringWithFormat:@"%.02f",diffusionData.lowPrice] forKey:@"Low Price"];
    [dataSourceDict setValue:[NSString stringWithFormat:@"%.02f",diffusionData.bidValue] forKey:@"Best Bid"];
    [dataSourceDict setValue:[NSString stringWithFormat:@"%.02f",diffusionData.askValue] forKey:@"Best Offer"];
    [dataSourceDict setValue:diffusionData.lastTradedTime forKey:@"Last Traded Time"];
    [dataSourceDict setValue:[NSString stringWithFormat:@"%@%.02f%%",diffusionData.netPriceChangeIndicator,percentage] forKey:@"% Change"];
    [dataSourceDict setValue:[NSString stringWithFormat:@"%.02f",diffusionData.fiftyTwoWeekHigh] forKey:@"52 Week High"];
    [dataSourceDict setValue:[NSString stringWithFormat:@"%.02f",diffusionData.fiftyTwoWeekLow] forKey:@"52 Week Low"];
    
    
    if(isEnlargedView)
        [self.enlargedQuotesTableView reloadData];
    else
        [self.quotesTableView reloadData];
    
}

#pragma NSNotification handler

-(void)updateGlobalSymbolData{
    TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    
    self.currentSymbol = symbolDetails.symbolData.tradeSymbolName;
     [dataSourceDict setValue:symbolDetails.symbolData.exchange forKey:@"Exchange"];
//    self.currentSymbol.
    NSLog(@"%@",symbolDetails.symbolData.exchange);
    
    if(self.currentSymbol){
        TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
        [diffusionHandler subscribe:symbolDetails.symbolData.subscriptionKey withContext:self];
        self.companynameLabel.text = symbolDetails.symbolData.companyName;
//        self.symbolNameLabel.text = self.currentSymbol;
        [_symbolButton setTitle:self.currentSymbol forState:UIControlStateNormal];
        self.widgetCompanynameLabel.text = self.companynameLabel.text;
        self.widgetSymbolNameLabel.text = self.symbolButton.titleLabel.text;
    }
}

//-(void)updateExchangeType:(NSNotification *)inNotification{
//    SBITradingUtility *utility = [SBITradingUtility sharedUtility];
//    NSLog(@"%@",inNotification.object);
//    int exchangeType = [[inNotification object] intValue];
//    [utility updateExchangeTypeWith:(EExchangeType)exchangeType];
//    self.currentExchangeType = [utility returnCurrentExchangeType];
//    
//   // [dataSourceDict setValue:[SBITradingUtility getTitleForEchangeType:self.currentExchangeType] forKey:@"Exchange"];
//    
//    if(isEnlargedView)
//        [self.enlargedQuotesTableView reloadData];
//    else
//        [self.quotesTableView reloadData];
//}

#pragma IBActions

-(IBAction)showEnlargedView:(id)sender{
    isEnlargedView = YES;
    [self.ttQuotesDelegate quotesViewControllerShouldPresentinEnlargedView:self.navigationController];
}

-(IBAction)dismissTheController:(id)sender{
    
    if(!self.shouldShowBackButton){
        isEnlargedView = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
//        self.navigationController.view.frame = self.previousScreenFrame;
//        self.navigationController.view.center = CGPointMake(512, 350);
        self.navigationController.view.bounds = self.previousScreenFrame;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(IBAction)goToTrade:(id)sender{
    
    for(id viewController in self.navigationController.viewControllers){
        if([viewController isKindOfClass:[TTTradePopoverController class]]){
//            self.navigationController.view.frame = self.previousScreenFrame;
//            self.navigationController.view.center = CGPointMake(512, 350);
            self.navigationController.view.bounds = self.previousScreenFrame;
            NSLog(@"nav controller %@",self.navigationController);
            NSLog(@"nav controller %@",self.navigationController.viewControllers);
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    
    TTTradePopoverController *tradeViewController = [[TTTradePopoverController alloc] initWithNibName:@"TTTradePopoverController" bundle:nil];
    tradeViewController.isModifyMode = NO;
    tradeViewController.previousScreenTitle = @"Quotes";
    tradeViewController.previousScreenFrame = self.view.frame;
    tradeViewController.shouldShowBackButton = YES;
    tradeViewController.delegate = self;
    
    [self.navigationController pushViewController:tradeViewController animated:YES];
    
}

-(IBAction)goToChart:(id)sender{
    for(id viewController in self.navigationController.viewControllers){
        if([viewController isKindOfClass:[TTChartViewController class]]){
//            self.navigationController.view.frame = self.previousScreenFrame;
//            self.navigationController.view.center = CGPointMake(512, 350);
            self.navigationController.view.bounds = self.previousScreenFrame;
            NSLog(@"Quotes nav object is %@",self.navigationController);
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    //the Quotes screen is not presented yet ...
    TTChartViewController *chartViewController = [[TTChartViewController alloc] initWithNibName:@"TTChartViewController" bundle:nil];
    chartViewController.previousScreenTitle = @"Quotes";
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
    watchListViewController.previousScreenTitle=@"Quotes";
    watchListViewController.currentSymbol = symbolDetails.symbolData;
    [self.navigationController pushViewController:watchListViewController animated:YES];
}

-(void)updateLabelBasedOnPriceIndicator:(NSString *)inPriceIndicator{
    UIColor *color;
    if([inPriceIndicator isEqualToString:@"+"])
        color= SYMBOL_PROFIT_LABEL_COLOR;
    else
        color= SYMBOL_LOSS_LABEL_COLOR;
    
    self.lastTradePriceLabel.textColor = self.widgetLastTradePriceLabel.textColor = self.priceChangeLabel.textColor = self.widgetPriceChangeLabel.textColor = color;
    
}


- (void)tradePopoverControllerDidPlaceTradeSuccessfully:(TTTradePopoverController *)inController  shouldShowOrders:(BOOL)showOrder
{
    [self dismissTheController:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    if(showOrder)
        [self performSelector:@selector(showOrder) withObject:nil afterDelay:1];
    else
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshOrderBook" object:nil];

}

-(void)showOrder
{
    dispatch_async(dispatch_get_main_queue(), ^{
        TTWidgetsViewController *widgetViewController = [(TTAppDelegate *)[[UIApplication sharedApplication] delegate] dashboardViewController].widgetsViewController;
        [widgetViewController showWidgetsofType:eOrdersMenuItem];
    });
}

@end
