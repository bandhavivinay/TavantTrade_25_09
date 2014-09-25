//
//  TTChartViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 1/31/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTChartViewController.h"
#import "TTQuotesViewController.h"
#import "TTTradePopoverController.h"
#import "TTWatchlistEntryViewController.h"
#import "SBITradingUtility.h"
#import "TTConstants.h"
#import "TTDiffusionData.h"
#import "TTAppDelegate.h"
#import "TTDashboardviewController.h"

@interface TTChartViewController ()
@property (nonatomic, weak) IBOutlet UIWebView *chartWebView;
@property (weak, nonatomic) IBOutlet UILabel *chartHeadingTitle;
@property (weak, nonatomic) IBOutlet UILabel *widgetChartHeadingTitle;
@property (nonatomic, weak) IBOutlet UIView *enlargedHeaderView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIView *menuView;
@property(nonatomic,strong)NSString *currentSymbol;
@property(nonatomic,weak)IBOutlet UILabel *symbolNameLabel;
@property(nonatomic,weak)IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ltpLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *highValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *askValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLabel;
@property (weak, nonatomic) IBOutlet UILabel *askLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetSymbolNameLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetCompanyNameLabel;
@property(nonatomic,weak)IBOutlet UISegmentedControl *durationSegmentControl;
@property(nonatomic,weak)IBOutlet UISegmentedControl *typeSegmentControl;
@property(nonatomic,weak)IBOutlet UIButton *lineChartButton;
@property(nonatomic,weak)IBOutlet UIButton *OHLChartButton;
@property(nonatomic,weak)IBOutlet UIButton *areaChartButton;
@property(nonatomic,weak)IBOutlet UIButton *candleStickChartButton;
@property(nonatomic,strong)NSMutableArray *buttonArray;
@property(nonatomic,weak)IBOutlet UIImageView *widgetChartView;
@property(nonatomic,assign)BOOL wasSuccessfulLoad;

@end

@implementation TTChartViewController

@synthesize isEnlargedView;

int count = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isEnlargedView = NO;
        _selectedFrequencyType = eOneWeek;
        _selectedChartType = eLineChart;
        _buttonArray = [[NSMutableArray alloc] init];
        _wasSuccessfulLoad = NO;
    }
    return self;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
//    self.navigationController.view.bounds = CGRectMake(0, 0, 1004, 700);
//    self.view.superview.bounds = CGRectMake(0, 0, 1004, 700);
    
    self.navigationController.view.frame = CGRectMake(0, 0, 1004, 700);
    self.navigationController.view.superview.bounds = CGRectMake(0, 0, 1004, 700);
    
    NSLog(@"chart nav object is %@",NSStringFromCGRect(self.navigationController.view.bounds));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGlobalSymbolData) name:@"UpdateGlobalSymbol" object:nil];
    
    //set initial position of menuview
    
    _menuView.frame = CGRectMake(-147, 0, _menuView.frame.size.width, _menuView.frame.size.height);
    [_chartWebView setClipsToBounds:YES];
    [_chartWebView addSubview:_menuView];
    
    _lineChartButton.frame = CGRectMake(0, 0, _lineChartButton.frame.size.width, _lineChartButton.frame.size.height);
    [_chartWebView addSubview:_lineChartButton];
    
    _lineChartButton.enabled = NO;
    
    if(self.shouldShowBackButton){
        [self.cancelButton setTitle:self.previousScreenTitle forState:UIControlStateNormal];
        [self.cancelButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [self.cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-10,0,0)];
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    //set the heading title ...
    _chartHeadingTitle.text = _widgetChartHeadingTitle.text = NSLocalizedStringFromTable(@"Chart_Button_Title", @"Localizable", @"Chart");
    _enlargedHeaderView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"ChartTitleBar"];
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"ChartTitleBar"];
    
    [self updateGlobalSymbolData];

    _askLabel.text=NSLocalizedStringFromTable(@"Ask", @"Localizable", @"Ask");
    _bidLabel.text=NSLocalizedStringFromTable(@"Bid", @"Localizable", @"Bid");
    _highLabel.text=NSLocalizedStringFromTable(@"High", @"Localizable", @"High");
    _lowLabel.text=NSLocalizedStringFromTable(@"Low", @"Localizable", @"Low");
    
    //set the font ...
    _widgetChartHeadingTitle.font = SEMI_BOLD_FONT_SIZE(19.0);
    _chartHeadingTitle.font = SEMI_BOLD_FONT_SIZE(22.0);
    _cancelButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);
    
    _symbolNameLabel.font = SEMI_BOLD_FONT_SIZE(20.0);
    _companyNameLabel.font = REGULAR_FONT_SIZE(17.0);
    
    _widgetCompanyNameLabel.font = _widgetSymbolNameLabel.font = SEMI_BOLD_FONT_SIZE(13.0);
    
    _askLabel.font = _bidLabel.font = _highLabel.font = _lowLabel.font = REGULAR_FONT_SIZE(18.0);
    _askValueLabel.font = _bidValueLabel.font = _highValueLabel.font = _lowValueLabel.font = REGULAR_FONT_SIZE(15.0);
    _ltpLabel.font = _changeLabel.font = SEMI_BOLD_FONT_SIZE(22.0);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:SEMI_BOLD_FONT_SIZE(16.0)
                                                           forKey:NSFontAttributeName];
    
    [self.durationSegmentControl setTitleTextAttributes:attributes
                                             forState:UIControlStateNormal];
    
    self.durationSegmentControl.tintColor = [SBITradingUtility getColorForComponentKey:@"Default"];
    
    [_buttonArray addObject:_lineChartButton];
    [_buttonArray addObject:_candleStickChartButton];
    [_buttonArray addObject:_areaChartButton];
    [_buttonArray addObject:_OHLChartButton];
    
    [self.durationSegmentControl setClipsToBounds:YES];
    _lineChartButton.selected = YES;
    [_lineChartButton setBackgroundImage:[UIImage imageNamed:@"1_ontouch.png"] forState:UIControlStateSelected];
    [_OHLChartButton setBackgroundImage:[UIImage imageNamed:@"2_ontouch.png"] forState:UIControlStateSelected];
    [_areaChartButton setBackgroundImage:[UIImage imageNamed:@"3_ontouch.png"] forState:UIControlStateSelected];
    [_candleStickChartButton setBackgroundImage:[UIImage imageNamed:@"4_ontouch.png"] forState:UIControlStateSelected];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.view.frame = self.view.frame;
    
    NSLog(@"%@ ..... %@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds));
    NSLog(@"%@",NSStringFromCGRect(self.navigationController.view.frame));
    
   
    NSString* html = [NSString stringWithFormat: @"<!DOCTYPE html><html><head><script src=\"jquery.min.js\" type=\"text/javascript\"></script><script src=\"highstock.js\"></script><script src=\"HighChartWrapper.js\"></script><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\"><meta name=\"apple-mobile-web-app-capable\" content=\"yes\"><meta name=\"apple-touch-fullscreen\" content=\"yes\"><link rel=\"stylesheet\" type=\"text/css\" href=\"chart.css\"/><body> <div id=\"container\"></div></body></html>"];
    
    [_chartWebView loadHTMLString: html baseURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *URL = [request URL];
    if ([[URL scheme] isEqualToString:@"chart"])
    {
        NSString *functionString = [URL resourceSpecifier];
        
        if ([functionString hasPrefix:@"Error"])
        {
            _wasSuccessfulLoad = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chart Loading Error" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
        else{
            _wasSuccessfulLoad = YES;
            //reload the widget view content ....
//            _lineChartButton.hidden = YES;
//            _menuView.hidden = YES;
//            UIGraphicsBeginImageContext(_chartWebView.frame.size);
//            [_chartWebView.layer renderInContext:UIGraphicsGetCurrentContext()];
//            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            _widgetChartView.image = viewImage;
//            //    _widgetChartView.backgroundColor = [UIColor colorWithPatternImage:viewImage];
//            _lineChartButton.hidden = NO;
//            _menuView.hidden = NO;
            return YES;
        }
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showEnlargedView:(id)sender{
    isEnlargedView = YES;
    [self.ttChartDelegate chartViewControllerShouldPresentinEnlargedView:self.navigationController];
    NSLog(@"%@ ..... %@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds));
}

- (IBAction)closeChartView:(id)sender {
    
    if(!self.shouldShowBackButton){
        isEnlargedView = NO;
        if(_wasSuccessfulLoad){
            _lineChartButton.hidden = YES;
            _menuView.hidden = YES;
            TTAppDelegate *delegate = (TTAppDelegate *)[[UIApplication sharedApplication] delegate];
            UIGraphicsBeginImageContext(_chartWebView.frame.size);
            [_chartWebView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            _widgetChartView.image = viewImage;
            delegate.chartImage = viewImage;
            //    _widgetChartView.backgroundColor = [UIColor colorWithPatternImage:viewImage];
            _lineChartButton.hidden = NO;
            _menuView.hidden = NO;
        }

        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        
        self.navigationController.view.frame = self.previousScreenFrame;
        self.navigationController.view.center = CGPointMake(512, 350);
//        self.navigationController.view.superview.bounds = self.previousScreenFrame;
//
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)openMenu:(id)sender{
    
    if(count %2 == 0){
        [UIView animateWithDuration:1.0 animations:^{
            _lineChartButton.enabled = YES;
            _menuView.frame = CGRectMake(75, 0, _menuView.frame.size.width, _menuView.frame.size.height);
        }];
    }
    else{
        [UIView animateWithDuration:1.0 animations:^{
            _lineChartButton.enabled = NO;
            _menuView.frame = CGRectMake(-146, 0, _menuView.frame.size.width, _menuView.frame.size.height);
        }];
    }
    count++;
    
}

-(IBAction)goToQuotes:(id)sender{
    
    for(id viewController in self.navigationController.viewControllers){
        if([viewController isKindOfClass:[TTQuotesViewController class]]){
//            self.navigationController.view.frame = self.previousScreenFrame;
//            self.navigationController.view.center = CGPointMake(512, 350);
            self.navigationController.view.frame = self.previousScreenFrame;
            self.navigationController.view.center = CGPointMake(512, 350);
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    //the Quotes screen is not presented yet ...
    TTQuotesViewController *quotesViewController = [[TTQuotesViewController alloc] initWithNibName:@"TTQuotesViewController" bundle:nil];
    quotesViewController.previousScreenTitle = @"Chart";
    quotesViewController.previousScreenFrame = self.view.bounds;
    quotesViewController.shouldShowBackButton = YES;
//    self.navigationController.view.bounds = CGPointMake(512, 350);
    quotesViewController.view.center = CGPointMake(512, 350);
    self.navigationController.view.center = CGPointMake(512, 350);
    [self.navigationController pushViewController:quotesViewController animated:YES];
    
}

-(IBAction)goToTrade:(id)sender{
    for(id viewController in self.navigationController.viewControllers){
        if([viewController isKindOfClass:[TTTradePopoverController class]]){
            self.navigationController.view.frame = self.previousScreenFrame;
            self.navigationController.view.center = CGPointMake(512, 350);
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    //the Quotes screen is not presented yet ...
    TTTradePopoverController *tradeViewController = [[TTTradePopoverController alloc] initWithNibName:@"TTTradePopoverController" bundle:nil];
    tradeViewController.isModifyMode = NO;
    tradeViewController.previousScreenTitle = @"Chart";
    tradeViewController.previousScreenFrame = self.view.frame;
    tradeViewController.shouldShowBackButton = YES;
    tradeViewController.delegate = self;
    tradeViewController.view.center = CGPointMake(512, 350);
    self.navigationController.view.center = CGPointMake(512, 350);
    [self.navigationController pushViewController:tradeViewController animated:YES];
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
    watchListViewController.previousScreenTitle = @"Chart";
    watchListViewController.shouldShowBackButton = YES;
    watchListViewController.currentSymbol = symbolDetails.symbolData;
    [self.navigationController pushViewController:watchListViewController animated:YES];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self reloadChart];
}

-(IBAction)chartFrequecyAction:(id)sender
{
    UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
    
    _selectedFrequencyType = segmentControl.selectedSegmentIndex;
    
    [self reloadChart];
    
}

-(IBAction)chartTypeAction:(id)sender
{
    UIButton *selectedButton = (UIButton *)sender;
    selectedButton.selected = YES;
    for(UIButton *button in _buttonArray)
        if(selectedButton.tag != button.tag)
            button.selected = NO;
    _selectedChartType = selectedButton.tag;
    
    [self reloadChart];
    
}


-(void)reloadChart
{
    NSString *function = [NSString stringWithFormat:@"addChart('%@','%@','%d','%d','%d', '%d', '%@')", [self  getStringKeyForChartType:_selectedChartType], @"6", 964, 520, _selectedFrequencyType, 1, [self getStringKeyForChartFrequencyType:_selectedFrequencyType]];
    [_chartWebView stringByEvaluatingJavaScriptFromString:function];
    
}

-(NSString *)getStringKeyForChartType:(EChartType) inType
{
    NSString *chartTypeString;
    
    switch (inType)
    {
        case eLineChart:
        {
            chartTypeString = @"line";
        }
            break;
        case eOHLCChart:
        {
            chartTypeString = @"ohlc";
        }
            break;
        case eAreaChart:
        {
            chartTypeString = @"area";
        }
            break;
        case eCandleStickChart:
        {
            chartTypeString = @"candlestick";
        }
            break;

        default:
            break;
    }
    return chartTypeString;
}

-(NSString *)getStringKeyForChartFrequencyType:(EChartFrequencyType) inType
{
    NSString *frequencyTypeString;
    switch ( inType) {
        case eOneDay:
        {
            frequencyTypeString = @"1day";
        }
            break;
        case eFiveDay:
        {
            //For Demo :
//            frequencyTypeString = @"5day";
              frequencyTypeString = @"1mon";
        }
            break;

        case eOneWeek:
        {
//            frequencyTypeString = @"1wek";
            frequencyTypeString = @"1day";
        }
            break;
        case eOneMonth:
        {
//            frequencyTypeString = @"1mon";
            frequencyTypeString = @"1mon";
        }
            break;
        case eSixMonth:
        {
//            frequencyTypeString = @"6mon";
            frequencyTypeString = @"1day";
        }
            break;
        case eOneYear:
        {
//            frequencyTypeString = @"1yer";
            frequencyTypeString = @"1mon";
        }
            break;

        default:
            break;
    }
    return frequencyTypeString;
}

#pragma NSNotification handler

-(void)updateGlobalSymbolData{
    TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    
    self.currentSymbol = symbolDetails.symbolData.tradeSymbolName;
    
    if(self.currentSymbol){
        TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
        [diffusionHandler subscribe:symbolDetails.symbolData.subscriptionKey withContext:self];
        self.companyNameLabel.text = symbolDetails.symbolData.companyName;
        self.symbolNameLabel.text = self.currentSymbol;
        self.widgetCompanyNameLabel.text = self.companyNameLabel.text;
        self.widgetSymbolNameLabel.text = self.currentSymbol;
    }
}

-(void)onDelta:(DFTopicMessage *)message{
    
    //find the row to be updated...
    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
    TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
    diffusionData = [diffusionData updateDiffusionDataWith:parsedArray];
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
    self.changeLabel.text = [NSString stringWithFormat:@"%.02f%%",percentage];
    self.ltpLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.lastSalePrice];
    self.askValueLabel.text = [NSString stringWithFormat:@"%.02f",diffusionData.askValue];
    self.bidValueLabel.text = [NSString stringWithFormat:@"%.02f",diffusionData.bidValue];
    self.highValueLabel.text = [NSString stringWithFormat:@"%.02f",diffusionData.highPrice];
    self.lowValueLabel.text = [NSString stringWithFormat:@"%.02f",diffusionData.lowPrice];
    
}


- (void)tradePopoverControllerDidPlaceTradeSuccessfully:(TTTradePopoverController *)inController  shouldShowOrders:(BOOL)showOrder
{
    [self closeChartView:nil];
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
