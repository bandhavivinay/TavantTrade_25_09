//
//  TTOptionChainViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 2/27/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTOptionChainViewController.h"
#import "TTConstants.h"
#import "SBITradingNetworkManager.h"
#import "SBITradingUtility.h"
#import "TTUrl.h"
#import "TTOptionChain.h"
#import "TTSymbolDetails.h"
#import "TTSymbolData.h"
#import "TTSymbolSearch.h"
#import "TTWatchlistEntryViewController.h"
#import "TTOrder.h"

@interface TTOptionChainViewController ()
@property(nonatomic,strong)TTGlobalSymbolSearchViewController *searchViewController;
@property(nonatomic,strong)NSString *todaysDateString;
@property(nonatomic,strong)IBOutlet UILabel *symbolNameLabel;
@property(nonatomic,strong)IBOutlet UILabel *companyNameLabel;
@property(nonatomic,strong)IBOutlet UILabel *widgetSymbolNameLabel;
@property(nonatomic,strong)IBOutlet UILabel *widgetCompanyNameLabel;
@property(nonatomic,strong)UIPopoverController *selectPopoverController;
@property(nonatomic,strong)UIPopoverController *optionsPopoverController;
@property(nonatomic,strong)IBOutlet UIView *popoverOptionView;
@property(nonatomic,strong)IBOutlet UIView *optionsPopoverView;
@property(nonatomic,strong)IBOutlet UITableView *popoverOptionTableView;
@property(nonatomic,strong)IBOutlet UITableView *optionsPopoverTableView;
@property(nonatomic,strong)IBOutlet UITableView *optionChainEnlargedTableView;
@property(nonatomic,strong)IBOutlet UITableView *optionChainWidgetTableView;
@property(nonatomic,strong)IBOutlet UIView *grayView;
@property(nonatomic,strong)NSMutableDictionary *symbolCellMapping;

@property(nonatomic,strong) TTOptionChain *selectedOptionChain;


@property(nonatomic,strong)NSMutableArray *optionChainsArray;
@property(nonatomic,strong)NSMutableArray *expiryDateArray;

@property(nonatomic,assign)NSString *currentInstrumentType;

@property(nonatomic,weak)IBOutlet UIView *enlargedHeaderView;
@property(nonatomic,weak)IBOutlet UIView *headerView;

@property(nonatomic,weak)IBOutlet UILabel *widgetHeaderLabel;
@property(nonatomic,weak)IBOutlet UILabel *headerLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetDateLabel;

@property(nonatomic,weak)IBOutlet UIButton *expiryDateButton;
@property(nonatomic,weak)IBOutlet UIButton *cancelButton;
@property(nonatomic,weak)IBOutlet UILabel *callsLabel;
@property(nonatomic,weak)IBOutlet UILabel *putsLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetCallsLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetPutsLabel;
@property(nonatomic,weak)IBOutlet UILabel *strikePriceLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetStrikePriceLabel;

@property(nonatomic,weak)IBOutlet UILabel *callsVolumeLabel;
@property(nonatomic,weak)IBOutlet UILabel *callsOILabel;
@property(nonatomic,weak)IBOutlet UILabel *callsBidLabel;
@property(nonatomic,weak)IBOutlet UILabel *callsAskLabel;
@property(nonatomic,weak)IBOutlet UILabel *callsLTPLabel;

@property(nonatomic,weak)IBOutlet UILabel *putsVolumeLabel;
@property(nonatomic,weak)IBOutlet UILabel *putsOILabel;
@property(nonatomic,weak)IBOutlet UILabel *putsBidLabel;
@property(nonatomic,weak)IBOutlet UILabel *putsAskLabel;
@property(nonatomic,weak)IBOutlet UILabel *putsLTPLabel;

@property(nonatomic,weak)IBOutlet UILabel *widgetCallsVolumeLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetCallsOILabel;

@property(nonatomic,weak)IBOutlet UILabel *widgetPutsVolumeLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetPutsOILabel;

@property(nonatomic,strong)NSArray *optionsArray;

@property(nonatomic,assign)BOOL updateSearchNotification;



@end

@implementation TTOptionChainViewController


@synthesize searchViewController = _searchViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _updateSearchNotification = NO;
    }
    return self;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    self.view.superview.bounds = CGRectMake(0, 0, 1008, 720);
    self.navigationController.view.frame = CGRectMake(0, 0, 1008, 700);
    self.navigationController.view.superview.bounds = CGRectMake(0, 0, 1008, 700);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.view.frame = self.view.frame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%d",_isVisitedFromOtherScreen);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGlobalSymbolData) name:@"UpdateGlobalSymbol" object:nil];
    
    _optionsArray = [NSArray arrayWithObjects:@"Trade",@"Add to Watchlist", nil];
    
    self.symbolCellMapping = [[NSMutableDictionary alloc] init];
    
    self.navigationController.navigationBarHidden = YES;
    _expiryDateButton.backgroundColor=[SBITradingUtility getColorForComponentKey:@"Default"];
    _expiryDateButton.layer.cornerRadius = 3.0f;
    if(!_isVisitedFromOtherScreen){
        _currentInstrumentType = [SBITradingUtility getInstrumentTypeURLKey:OPTION_STOCK];
        //load the default symbol ...
        [self loadInitialSymbolForTheScreen];
    }
    else{
//        _currentInstrumentType = _currentSymbol.instrumentType
        [self refreshUI];
    }
    
    _enlargedHeaderView.backgroundColor = _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"OptionChainTitleBar"];
    
    //set the font ...
    _expiryDateButton.titleLabel.font = _callsAskLabel.font = _callsBidLabel.font = _callsLTPLabel.font = _callsOILabel.font = _callsVolumeLabel.font = _putsAskLabel.font = _putsBidLabel.font = _putsLTPLabel.font = _putsOILabel.font = _putsVolumeLabel.font = _strikePriceLabel.font = REGULAR_FONT_SIZE(17.0);
    
    _widgetCallsOILabel.font = _widgetCallsVolumeLabel.font = _widgetPutsOILabel.font = _widgetPutsVolumeLabel.font = _widgetStrikePriceLabel.font = REGULAR_FONT_SIZE(15.0);
    
    _widgetSymbolNameLabel.font = _widgetCompanyNameLabel.font = SEMI_BOLD_FONT_SIZE(13.0);
    
    _widgetCallsLabel.font = _widgetPutsLabel.font = REGULAR_FONT_SIZE(18.0);
    
    _callsLabel.font = _putsLabel.font = _symbolNameLabel.font = _companyNameLabel.font = REGULAR_FONT_SIZE(20.0);
    
    _widgetDateLabel.font = REGULAR_FONT_SIZE(13.0);
    
    _cancelButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);
    
    _headerLabel.font = SEMI_BOLD_FONT_SIZE(22.0);
    _widgetHeaderLabel.font = SEMI_BOLD_FONT_SIZE(19.0);
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _updateSearchNotification = NO;
}

-(void)loadInitialSymbolForTheScreen{
    
    //get the list of symbols after the search...
    NSMutableArray *symbolResultArray = [[NSMutableArray alloc] init];
    NSString *searchText = @"State";
    if([searchText length] > 0){
        NSString *exchangeTypeString = [SBITradingUtility getTitleForEchangeType:eNSE];
        NSString *relativePathString = [NSString stringWithFormat:@"/instruments/%@/%@/%@",searchText,exchangeTypeString
                                        ,[SBITradingUtility getInstrumentTypeURLKey:OPTION_STOCK]];
        NSLog(@"Request URL is %@",relativePathString);
        SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
        [networkManager makeGETRequestWithRelativePath:relativePathString responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
            
            NSError *jsonParsingError = nil;
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if(responseArray){
                for(id symbolData in responseArray){
                    TTSymbolData *currentSymbolData = [[TTSymbolData alloc] initWithDictionary:symbolData];
                    [symbolResultArray addObject:currentSymbolData];
                    
                }
            }
            if([symbolResultArray count] > 0){
                _currentSymbol = [symbolResultArray objectAtIndex:0];
                [self refreshUI];
            }
        }];
        
    }
    
}


-(void)getUniqueExpiryDateArray{
    NSString *relativePathString = [NSString stringWithFormat:@"/instruments/expiry/%@/%@/%@",self.currentSymbol.symbolName,@"NSE",_currentInstrumentType];
    NSLog(@"Request URL is %@",relativePathString);
    
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    [networkManager makeGETRequestWithRelativePath:relativePathString responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        //        NSLog(@"data is %d",data.length);
        if([data length] > 0){
            NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
            //            NSLog(@"%@ and status code is %@",jsonString,response);
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"[" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"]" withString:@""];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSArray * tempArray = [jsonString componentsSeparatedByString:@","];
            self.expiryDateArray = [[NSMutableArray alloc] initWithArray:tempArray];
            NSLog(@"Before dispatch First object is %@",[tempArray objectAtIndex:0]);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *expiryDate = [self.expiryDateArray objectAtIndex:0];
                NSLog(@"First object is %@",expiryDate);
                [_expiryDateButton setTitle:expiryDate forState:UIControlStateNormal];
                NSLog(@"Title is %@ ...... %@",expiryDate,_expiryDateButton.titleLabel.text);
                _widgetDateLabel.text = _expiryDateButton.titleLabel.text;
                [self getTheOptionChainValues];
                NSLog(@"Title is %@ ...... %@",expiryDate,_expiryDateButton.titleLabel.text);
                [self.popoverOptionTableView reloadData];
                
            });
        }
    }];

}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getTheOptionChainValues{
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    NSString *relativePath = [TTUrl optionChainUrl];
    self.optionChainsArray = [[NSMutableArray alloc] init];
    relativePath = [relativePath stringByAppendingFormat:@"%@/%@/%@",_currentSymbol.symbolName,_currentSymbol.exchange,_expiryDateButton.titleLabel.text];
    TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
    
    //unsubscribe the previous symbols...
    for(TTOptionChain *optionChain in self.optionChainsArray){
        [diffusionHandler unsubscribe:optionChain.callOption.callsSubscriptionKey withContext:self];
        [diffusionHandler unsubscribe:optionChain.putOption.putsSubscriptionKey withContext:self];
    }
    
    [networkManager makeGETRequestWithRelativePath:relativePath responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        NSError *jsonParsingError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
        NSLog(@"OC URL is %@",relativePath);
        NSLog(@"%@ and status code is %@",jsonString,response);
        NSLog(@"Order Response is %@",responseDictionary);
        
        if([data length] > 0){
            
            NSError *jsonParsingError = nil;
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            
            for(NSDictionary *optionChain in responseArray){
                //Create the TTOPtionChain Object for each object recieved ...
                TTOptionChain *recievedOC = [[TTOptionChain alloc] initWithOCDictionary:optionChain];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [diffusionHandler subscribe:recievedOC.callOption.callsSubscriptionKey withContext:self];
                    [diffusionHandler subscribe:recievedOC.putOption.putsSubscriptionKey withContext:self];
                    
                });
                
                [self.optionChainsArray addObject:recievedOC];
                
            }
            NSLog(@"OC array ids %@",self.optionChainsArray);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(_isEnlargedView == YES){
                    [self.optionChainEnlargedTableView reloadData];
                    [self.optionChainWidgetTableView reloadData];
                }
                else
                    [self.optionChainWidgetTableView reloadData];
            });
            
        }
        
        
    }];
    
}

#pragma NSNotification handler

-(void)updateGlobalSymbolData{
    if(_updateSearchNotification){
        TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
        NSLog(@"symbol is %@",symbolDetails.symbolData.symbolName);
        self.currentSymbol = symbolDetails.symbolData;
        
        if(self.currentSymbol){
            TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
            [diffusionHandler subscribe:symbolDetails.symbolData.subscriptionKey withContext:self];
            self.symbolNameLabel.text = self.currentSymbol.tradeSymbolName;
            self.companyNameLabel.text = self.currentSymbol.companyName;
            //        self.widgetCompanynameLabel.text = self.companynameLabel.text;
            //        self.widgetSymbolNameLabel.text = self.symbolButton.titleLabel.text;
        }
        [self refreshUI];
    }

}

#pragma Diffusion Delegates

-(void)onDelta:(DFTopicMessage *)message{
    
    //find the row to be updated...
    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
    for(TTOptionChain*optionChain in self.optionChainsArray){
        TTCallOption *callOption = optionChain.callOption;
        TTPutOption *putOption = optionChain.putOption;
        
        if([callOption.callsSubscriptionKey isEqualToString:message.topic] && [self.symbolCellMapping objectForKey:message.topic]!=NULL){
            //access the index path...
            callOption = [callOption updateWithCallsDictionary:parsedArray];
            [self.optionChainEnlargedTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self.symbolCellMapping valueForKey:message.topic]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.optionChainWidgetTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self.symbolCellMapping valueForKey:message.topic]] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        
        if([putOption.putsSubscriptionKey isEqualToString:message.topic] && [self.symbolCellMapping objectForKey:message.topic]!=NULL){
            //access the index path...
            putOption = [putOption updateWithPutsDictionary:parsedArray];
            [self.optionChainEnlargedTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self.symbolCellMapping valueForKey:message.topic]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.optionChainWidgetTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self.symbolCellMapping valueForKey:message.topic]] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }

        
    }
}

#pragma IBActions

-(IBAction)showTheSearchScreen:(id)sender{
    _grayView.hidden = NO;
    _updateSearchNotification = YES;
    if(!_searchViewController)
    {
        _searchViewController = [[TTGlobalSymbolSearchViewController alloc] initWithNibName:@"TTGlobalSymbolSearchViewController" bundle:nil];
        _searchViewController.searchType = eOptionChainSearch;
        _searchViewController.delegate = self;
        _searchViewController.delegate = self;
    }
    _searchViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:_searchViewController animated:YES completion:nil];
}

-(IBAction)addToWatchlist:(id)sender{
    
    //show a list of watchlist to the user ...
    //show all watchlists...
//    TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    TTWatchlistEntryViewController *watchListViewController = [[TTWatchlistEntryViewController alloc] initWithNibName:@"TTWatchlistEntryViewController" bundle:nil];
    SBITradingUtility *utilityObj = [SBITradingUtility sharedUtility];
    watchListViewController.loadWatchlistDelegate = utilityObj.watchlistController;

    watchListViewController.parentController = self;
    watchListViewController.isCalledFromOtherScreen = YES;
    watchListViewController.previousScreenTitle = @"OC";
    watchListViewController.previousScreenFrame = self.view.frame;
    watchListViewController.shouldShowBackButton = YES;
    watchListViewController.currentSymbol = _currentSymbol;
    [self.navigationController pushViewController:watchListViewController animated:YES];
}

-(IBAction)showEnlargedView:(id)sender{
    _isEnlargedView = YES;
    [self.optionChainDelegate optionChainViewControllerShouldPresentinEnlargedView:self.navigationController];
}

-(IBAction)dismissTheController:(id)sender{
    _isEnlargedView = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissPopOver{

    if([self.selectPopoverController isPopoverVisible]){
        [self.selectPopoverController dismissPopoverAnimated:YES];
    }
    if([self.optionsPopoverController isPopoverVisible]){
        [self.optionsPopoverController dismissPopoverAnimated:YES];
        
    }
    self.selectPopoverController = nil;
    self.optionsPopoverController = nil;
}

-(IBAction)selectExpiryDate:(id)sender{
    [self dismissPopOver];
    
    UIViewController* controller = [[UIViewController alloc] init];
    controller.view = self.popoverOptionView;
    
    self.selectPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self.selectPopoverController setPopoverContentSize:CGSizeMake(self.popoverOptionView.frame.size.width, self.popoverOptionView.frame.size.height)];
    [self.selectPopoverController presentPopoverFromRect:[_expiryDateButton frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}

#pragma UITableView Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(showDummyData)
//    else
//        return [self.symbolArray count];
    
    if(tableView == _optionChainEnlargedTableView)
        return [self.optionChainsArray count];
    else if(tableView == _optionChainWidgetTableView)
        return [self.optionChainsArray count];
    else if(tableView == _popoverOptionTableView)
        return [self.expiryDateArray count];
    else if(tableView == _optionsPopoverTableView)
        return 2;
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _optionChainWidgetTableView){
        static NSString *cellIdentifier = @"Cell";
        TTOptionChainTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTOptionChainWidgetTableViewCell" owner:self options:nil];
            
            for(id oneObject in nib) {
                
                if([oneObject isKindOfClass:[TTOptionChainTableViewCell class]]) {
                    cell = (TTOptionChainTableViewCell *)oneObject;
                    cell.seriesSelectedDelegate = self;
                    cell.callVolumeLabel.font = cell.putVolumeLabel.font = cell.callOILabel.font = cell.putOILabel.font = cell.strikePrice.font = REGULAR_FONT_SIZE(12.5);
                }
                
            }
            
        }
        if([self.optionChainsArray count] > 0)
            [self configureCell:cell withIndex:indexPath];
        return cell;
    }
    else if(tableView == _optionChainEnlargedTableView){
        static NSString *cellIdentifier = @"EnlargedCell";
        TTOptionChainTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTOptionChainTableViewCell" owner:self options:nil];
            
            for(id oneObject in nib) {
                
                if([oneObject isKindOfClass:[TTOptionChainTableViewCell class]]) {
                    cell = (TTOptionChainTableViewCell *)oneObject;
                    cell.seriesSelectedDelegate = self;
                    cell.callVolumeLabel.font = cell.putVolumeLabel.font = cell.callOILabel.font = cell.putOILabel.font = cell.strikePrice.font = cell.callLTPLabel.font = cell.putLTPLabel.font = cell.callBidLabel.font = cell.putBidLabel.font = cell.callAskLabel.font = cell.putAskLabel.font = REGULAR_FONT_SIZE(16.5);
                }
                
            }
            
        }
        if([self.optionChainsArray count] > 0)
            [self configureCell:cell withIndex:indexPath];
        return cell;
    }
    else if(tableView == _optionsPopoverTableView){
        static NSString *cellIdentifier = @"OptionCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = [_optionsArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:11.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"OptionCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = [self.expiryDateArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:11.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissPopOver];
    if(tableView == _popoverOptionTableView){
        [self.expiryDateButton setTitle:[self.expiryDateArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(getTheOptionChainValues) userInfo:nil repeats:NO];// [self getTheOptionChainValues];
    }
    else if(tableView == _optionsPopoverTableView){
        //give the respective action .....
        if(indexPath.row == 0){
            //Trade Option Selected ...
            TTOrder *dataSource = [[TTOrder alloc] init];
            dataSource.symbolData.tradeSymbolName = _currentSymbol.tradeSymbolName;
            dataSource.symbolData.symbolName = _currentSymbol.symbolName;
            dataSource.subscriptionKey = _currentSymbol.subscriptionKey;
            dataSource.symbolData.companyName = _currentSymbol.companyName;
            TTTradePopoverController *tradeViewController = [[TTTradePopoverController alloc] initWithNibName:@"TTTradePopoverController" bundle:nil];
            tradeViewController.tradeDataSource = dataSource;
            tradeViewController.isModifyMode = YES;
            tradeViewController.previousScreenTitle = @"OC";
            tradeViewController.previousScreenFrame = self.view.frame;
            tradeViewController.shouldShowBackButton = YES;
            [self.navigationController pushViewController:tradeViewController animated:YES];

        }
        else{
            //Add to watchlist Selected ...
            
            //Get the symbol Detail ...
            
            NSString *relativePathString = [NSString stringWithFormat:@"instruments/%@/%@/%@/%@/%@/%@/%@",_currentSymbol.symbolName,_currentSymbol.exchange,[SBITradingUtility getInstrumentTypeURLKey:OPTION_STOCK],_currentSymbol.series,_selectedOptionChain.selectedOption,self.expiryDateButton.titleLabel.text,_selectedOptionChain.strikePrice];
            NSLog(@"Request URL is %@",relativePathString);
            SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
            [networkManager makeGETRequestWithRelativePath:relativePathString responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
                //            NSLog(@"data is %d",data.length);
                if([data length] > 0){
                    NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
                    NSLog(@"%@ and status code is %@",jsonString,response);
                    NSError *jsonParsingError = nil;
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
                    //                NSLog(@"Symbol Search Instrument is %@",responseDictionary);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        TTSymbolData *symbolData = [[TTSymbolData alloc] initWithDictionary:responseDictionary];
                        symbolData.jsonRawDictionary = responseDictionary;
                        _currentSymbol = symbolData;
                        
                        
                        TTWatchlistEntryViewController *watchListViewController = [[TTWatchlistEntryViewController alloc] initWithNibName:@"TTWatchlistEntryViewController" bundle:nil];
                        SBITradingUtility *utilityObj = [SBITradingUtility sharedUtility];
                        watchListViewController.loadWatchlistDelegate = utilityObj.watchlistController;
                        
                        watchListViewController.parentController = self;
                        watchListViewController.isCalledFromOtherScreen = YES;
                        watchListViewController.previousScreenTitle = @"OC";
                        watchListViewController.previousScreenFrame = self.view.frame;
                        watchListViewController.shouldShowBackButton = YES;
                        watchListViewController.currentSymbol = _currentSymbol;
                        [self.navigationController pushViewController:watchListViewController animated:YES];
                    });
                }
            }];
        }
    }
    [self dismissPopOver];
}

-(void)configureCell:(TTOptionChainTableViewCell *)cell withIndex:(NSIndexPath *)indexPath{
    TTOptionChain *currentOptionChain = [self.optionChainsArray objectAtIndex:indexPath.row];
    if(![[self.symbolCellMapping allKeys] containsObject:currentOptionChain.callOption.callsSubscriptionKey])
        [self.symbolCellMapping setValue:indexPath forKey:currentOptionChain.callOption.callsSubscriptionKey];
    
    if(![[self.symbolCellMapping allKeys] containsObject:currentOptionChain.putOption.putsSubscriptionKey])
        [self.symbolCellMapping setValue:indexPath forKey:currentOptionChain.putOption.putsSubscriptionKey];
    cell.strikePrice.text = [NSString stringWithFormat:@"%.2f",[currentOptionChain.strikePrice doubleValue]];
    [cell updateCellWithCallOption:currentOptionChain.callOption andPutOption:currentOptionChain.putOption];
    
}

-(void)refreshUI{
    _symbolNameLabel.text = _widgetSymbolNameLabel.text = self.currentSymbol.tradeSymbolName;
    _companyNameLabel.text = _widgetCompanyNameLabel.text = self.currentSymbol.companyName;
    _currentInstrumentType = self.currentSymbol.instrumentType;
    [self getUniqueExpiryDateArray];
}

#pragma Delegates

-(void)setSelectedSeries:(NSString *)inSeries forCell:(TTOptionChainTableViewCell *)inCell{
    //to find the index ...
    NSIndexPath *indexPath = [_optionChainEnlargedTableView indexPathForCell:inCell];
    _selectedOptionChain = [self.optionChainsArray objectAtIndex:indexPath.row];
    _selectedOptionChain.selectedOption = inSeries;
    NSLog(@"Indexpath row is %d for %@ with strike price %@",indexPath.row,inSeries,_selectedOptionChain.strikePrice);
    float x = 0;
    if([inSeries isEqualToString:@"CE"])
        x = 210;
    else
        x = 780;
    
    [self dismissPopOver];
    
    UIViewController* controller = [[UIViewController alloc] init];
    controller.view = self.optionsPopoverView;
    
    self.optionsPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self.optionsPopoverController setPopoverContentSize:CGSizeMake(self.optionsPopoverView.frame.size.width, self.optionsPopoverView.frame.size.height)];
    [self.optionsPopoverController presentPopoverFromRect:[inCell convertRect:CGRectMake(x, 7 , 20, 20) toView:self.optionChainEnlargedTableView] inView:self.optionChainEnlargedTableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

#pragma Search delegates

- (void) globalSymbolSearchViewControllerDidCancelSearch:(TTGlobalSymbolSearchViewController *)inController{
    [inController dismissViewControllerAnimated:YES completion:nil];
    _grayView.hidden = YES;
}

-(void)globalSymbolSearchViewController:(TTGlobalSymbolSearchViewController *)inController didSelectSymbol:(TTSymbolData *)inSymbol{
    _grayView.hidden = YES;
    //update the global symbol ...
    
    NSLog(@"Selected symbol is %@",inSymbol.instrumentType);
    _currentSymbol = inSymbol;
    [self refreshUI];
    [inController dismissViewControllerAnimated:YES completion:nil];
}

@end
