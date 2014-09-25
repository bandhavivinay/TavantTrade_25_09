
//
//  TTWatchlistController.m
//  TavantTrade
//
//  Created by Bandhavi on 1/6/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTWatchlistController.h"
#import "SBITradingNetworkManager.h"
#import "SBITradingUtility.h"
#import "TTDiffusionHandler.h"
#import "TTDiffusionData.h"
#import "TTCreateWatchListViewController.h"
#import "TTQuotesViewController.h"
#import "TTAlertView.h"
#import "TTCustomViewController.h"
#import "TTConstants.h"
#import "TTOptionChainViewController.h"
#import "TTAppDelegate.h"
#import "TTDashboardViewController.h"
#import "TTUrl.h"



@interface TTWatchlistController ()
@property(nonatomic,weak)IBOutlet UIView *navView;
@property(nonatomic,strong)UIPopoverController *selectWatchlistPopoverController;
@property(nonatomic,strong)NSMutableArray *watchListArray;
@property(nonatomic,weak)IBOutlet UITableView *symbolListTableView1;
@property(nonatomic,weak)IBOutlet UITableView *symbolListTableView2;
@property(nonatomic,strong)NSMutableArray *symbolListArray;
@property(nonatomic,strong)NSMutableDictionary *symbolCellMapping;
//@property(nonatomic,strong)TTDiffusionHandler *diffusion;
@property(nonatomic,strong)TTCreateWatchListViewController *editWatchListVieController;
@property(nonatomic,strong)TTQuotesViewController *quotesViewController;
@property(nonatomic,strong)TTTradePopoverController *tradeViewController;
@property(nonatomic,strong)TTOptionChainViewController *optionChainViewController;
@property(nonatomic,strong)UINavigationController *quotesViewNavigationController;
@property(nonatomic,strong)UINavigationController *tradeViewNavigationController;
@property(nonatomic,strong)NSIndexPath *indexPathToBeDeleted;
@property(nonatomic,strong)UINavigationController *watchlistEntryNavigationController;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property(nonatomic,strong)NSMutableArray *watchlistVisibleColumnsArray;
@property(nonatomic,weak)IBOutlet UIScrollView *tableScrollView;
@property(nonatomic,strong)IBOutlet UIView *optionsMenuView;
@property(nonatomic,weak)IBOutlet UITableView *optionMenuTableView;
@property(nonatomic,strong)NSMutableArray *optionMenuArray;
@property(nonatomic,strong)UIPopoverController* optionsPopoverViewController;
@end

@implementation TTWatchlistController

@synthesize selectWatchlistPopoverController,watchListArray;
@synthesize btnAddSymbol = _btnAddSymbol;
@synthesize btnWatchlist = _btnWatchlist;
@synthesize watchlistEntryNavigationController;

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

-(void)reloadWatchlistColumns{
    NSMutableArray *watchlistColumns = [[NSUserDefaults standardUserDefaults] objectForKey:KWatchlistColumnSetting];
    
    if([watchlistColumns count] == 0)
    {
        watchlistColumns = [[NSMutableArray alloc] initWithObjects:
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eExpiryDate],@"Type", @"Expiry Date", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eLastTradedSize],@"Type", @"Last TradeSize", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eLCL],@"Type", @"Lower Circuit Limit", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eOI],@"Type", @"Open Interest", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eOptType],@"Type", @"Option Type", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eRollingOI],@"Type", @"Rolling OI", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eStrike],@"Type", @"Strike", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eUnderlier],@"Type", @"Underlier", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eUCL],@"Type", @"Upper Circuit Limit", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eVWAP],@"Type", @"VWAP", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eOfferSize],@"Type", @"Offer Size", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eInstrument],@"Type", @"Instrument", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                           // [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eOffer],@"Type", @"Offer", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],//[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eOffer],@"Type", @"Close", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                            nil];
        [[NSUserDefaults standardUserDefaults] setObject:watchlistColumns forKey:KWatchlistColumnSetting];
    }
    _watchlistVisibleColumnsArray = [[NSMutableArray alloc] init];
    float width = TABLE_WIDTH;
    for(NSDictionary *columns in watchlistColumns){
        if([columns valueForKey:@"ShouldShow"] == [NSNumber numberWithBool:YES]){
            [_watchlistVisibleColumnsArray addObject:columns];
            float columnWidth = 100;//[SBITradingUtility getWatchlistColumnWidthFor:[[columns valueForKey:@"Type"] floatValue]];
            width+=columnWidth+COLUMN_OFFSET;
            
        }
    }
    //    width+=COLUMN_OFFSET;
    CGRect tableRect = CGRectMake(_symbolListTableView2.frame.origin.x, _symbolListTableView2.frame.origin.y, width, _symbolListTableView2.frame.size.height);
    _symbolListTableView2.frame = tableRect;
    _tableScrollView.contentSize = CGSizeMake(width, _tableScrollView.frame.size.height);
    [self.symbolListTableView2 reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.symbolListTableView1.editing = NO;
    self.symbolListTableView2.editing = NO;
    [self reloadWatchlistColumns];
    self.symbolListArray = [[NSMutableArray alloc] init];
    self.symbolCellMapping = [[NSMutableDictionary alloc] init];
    self.watchListArray = [[NSMutableArray alloc] init];
    self.watchlistNameLabel.font = SEMI_BOLD_FONT_SIZE(19.0);
    
    SBITradingUtility *utilityObj = [SBITradingUtility sharedUtility];
    utilityObj.watchlistController = self;
    _optionMenuArray = [[NSMutableArray alloc] initWithObjects:[SBITradingUtility getTitleForWatchlistActionType:eTradeAction],[SBITradingUtility getTitleForWatchlistActionType:eQuoteAction],[SBITradingUtility getTitleForWatchlistActionType:eDeleteSymbolAction],[SBITradingUtility getTitleForWatchlistActionType:eOptionChainAction], nil];
    
    [self getWatchList];
    //lets initiate the diffusion server...
    
    //    diffusion = [TTDiffusionHandler sharedDiffusionManager];
    //    [diffusion initDiffusion];
    //    [diffusion connectWithViewControllerContext:self];
    
    //add swipe gesture on navView...
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(navigateToNextScreen:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.navView addGestureRecognizer:swipeGestureRecognizer];
    
    //add long press gesture on the tableview ...
    UILongPressGestureRecognizer *longPressGestureRecognizer1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showOptionMenu1:)];
    longPressGestureRecognizer1.delegate = self;
    [_symbolListTableView1 addGestureRecognizer:longPressGestureRecognizer1];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showOptionMenu2:)];
    longPressGestureRecognizer2.delegate = self;
    [_symbolListTableView2 addGestureRecognizer:longPressGestureRecognizer2];
    
    // Do any additional setup after loading the view from its nib.
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"WatchListTitleBar"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(watchlistSettingsDidChange:) name:KWatchlistSettingsDidChangeNotification object:nil];
    
}

-(void)watchlistSettingsDidChange:(NSNotification *)notificationObj{
    [self reloadWatchlistColumns];
}

-(void)navigateToNextScreen:(UISwipeGestureRecognizer *)recognizer{
    [self.watchlistDelegate didNavigateToNewsScreen];
}

-(void)showOptionMenu2:(UILongPressGestureRecognizer *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        CGPoint p2 = [recognizer locationInView:_symbolListTableView2];
        NSIndexPath *indexPath2 = [_symbolListTableView2 indexPathForRowAtPoint:p2];
        if (indexPath2 == nil)
            NSLog(@"long press on table view but not on a row");
        else{
            NSLog(@"long press on table view2 at row %d", indexPath2.row);
            self.indexPathToBeDeleted = indexPath2;
            [self presentMenuAt:p2 forTableView:_symbolListTableView2];
        }
        [_optionMenuTableView reloadData];
    }
}

-(void)dismissPopOver{
    if([_optionsPopoverViewController isPopoverVisible]){
        [_optionsPopoverViewController dismissPopoverAnimated:YES];
    }
    _optionsPopoverViewController = nil;
    
}

-(void)presentMenuAt:(CGPoint)inPoint forTableView:(UITableView *)inTableView{
    [self dismissPopOver];
    UIViewController *optionsViewController = [[UIViewController alloc] init];
    optionsViewController.view = _optionsMenuView;
    _optionsPopoverViewController = [[UIPopoverController alloc] initWithContentViewController:optionsViewController];
    [_optionsPopoverViewController setPopoverContentSize:CGSizeMake(_optionsMenuView.frame.size.width, _optionsMenuView.frame.size.height)];
    
    CGRect modifiedFrame = CGRectMake(inPoint.x, inPoint.y, 5,5);
    CGRect frame;
//    if(CGRectContainsPoint(_symbolListTableView1.bounds, inPoint))
        frame = [self.view convertRect:modifiedFrame fromView:inTableView];
//    else
//        frame = [self.view convertRect:modifiedFrame fromView:_symbolListTableView2];
    [_optionsPopoverViewController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:(UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight) animated:YES];
    
}

-(void)showOptionMenu1:(UILongPressGestureRecognizer *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        CGPoint p1 = [recognizer locationInView:_symbolListTableView1];
        
        NSIndexPath *indexPath1 = [_symbolListTableView1 indexPathForRowAtPoint:p1];
        
        if (indexPath1 == nil)
            NSLog(@"long press on table view but not on a row");
        else{
            NSLog(@"long press on table view1 at row %d", indexPath1.row);
            self.indexPathToBeDeleted = indexPath1;
            [self presentMenuAt:p1 forTableView:_symbolListTableView1];
        }
        [_optionMenuTableView reloadData];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Diffusion Delegates

//-(void)onConnectionWithStatus:(BOOL)isConnected{
//
//    //get the watchlist...
//
////    if(isConnected){
//        [self getWatchList];
////    }
//
//}

-(void)onDelta:(DFTopicMessage *)message{
    
    //find the row to be updated...
    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
    for(id symbols in self.symbolListArray){
        TTDiffusionData *diffusionData = (TTDiffusionData *)symbols;
        if([diffusionData.symbolData.subscriptionKey isEqualToString:message.topic] && [self.symbolCellMapping objectForKey:message.topic]!=NULL){
            //access the index path...
            diffusionData = [diffusionData updateDiffusionDataWith:parsedArray];
            [self.symbolListTableView1 beginUpdates];
            [self.symbolListTableView1 reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self.symbolCellMapping valueForKey:message.topic]] withRowAnimation:UITableViewRowAnimationAutomatic];
            NSLog(@"dict is %d",self.symbolCellMapping.count);
            NSLog(@"Symbol is %@",[self.symbolCellMapping valueForKey:message.topic]);
            
            [self.symbolListTableView1 endUpdates];
            
            [self.symbolListTableView2 beginUpdates];
            [self.symbolListTableView2 reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self.symbolCellMapping valueForKey:message.topic]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.symbolListTableView2 endUpdates];
            break;
        }
    }
}


#pragma delegates

//-(void)dismissThePopOver{
//    if([selectWatchlistPopoverController isPopoverVisible])
//        [selectWatchlistPopoverController dismissPopoverAnimated:YES];
//}

-(void)refreshWatchlist:(TTWatchlist *)inWatchlist{
    
    NSString *relativePathString = [NSString stringWithFormat:@"/%d/%@",inWatchlist.watchlistID,inWatchlist.isSystemWatchlist];
    
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    [networkManager makeGETRequestWithRelativePath:[[TTUrl watchListURL] stringByAppendingString:relativePathString] responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
        NSLog(@"%@ and status code is %@",jsonString,response);
        NSError *jsonParsingError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadWatchlist:inWatchlist With:[responseDictionary valueForKey:@"instumentVOList"]];
        });
        
    }];

}

-(void)showWatchlist:(TTWatchlist *)watchlist{
    [self displayWatchList:watchlist];
}


-(void)loadSymbolsForWatchList:(NSArray *)rawDataArray andWatchlistObject:(TTWatchlist *)watchlistObj{
    
    //    if([selectWatchlistPopoverController isPopoverVisible])
    //        [selectWatchlistPopoverController dismissPopoverAnimated:YES];
    NSLog(@"The raw data array is %@",rawDataArray);
    
//    [self.symbolCellMapping removeAllObjects];
    self.symbolCellMapping = [[NSMutableDictionary alloc] init];
    
    self.currentDisplayedWatchlist = watchlistObj;
    self.watchlistNameLabel.text = watchlistObj.watchListName;
    [self loadWatchlist:watchlistObj With:rawDataArray];
}

-(void)getWatchList{
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    [networkManager makeGETRequestWithRelativePath:[TTUrl watchListURL] responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        NSError *jsonParsingError = nil;
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        if(responseArray){
            self.watchListArray = [[NSMutableArray alloc] init];
            for(id watchlist in responseArray){
                TTWatchlist *watchListObj = [[TTWatchlist alloc] init];
                watchListObj.watchlistID = [[watchlist valueForKey:@"id"] intValue];
                watchListObj.watchListName = [watchlist valueForKey:@"name"];
                watchListObj.isDefaultWatchlist = ([[watchlist valueForKey:@"isDefaultMarketWatch"] intValue] == 1)?@"true":@"false";
                watchListObj.isSystemWatchlist = ([[watchlist valueForKey:@"isSystemMarketWatch"] intValue] == 1)?@"true":@"false";
                
                [self.watchListArray addObject:watchListObj];
            }
            //get the first watchlist...
            dispatch_async(dispatch_get_main_queue(), ^{
                NSNumber *watchlistIDObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastSeenWatchlist"];
                if(watchlistIDObject!=nil){
                    [self getWatchlistByid:[watchlistIDObject intValue]];
                }
                else{
                    [self getFirstWatchListWithId];
                }
                    
            });
        }
        
    }];
    
}

-(TTWatchlist *)returnWatchListById:(int)watchlistId{
    TTWatchlist *selectedWatchlist = NULL;
    for(TTWatchlist *watchlist in self.watchListArray){
        if(watchlist.watchlistID == watchlistId){
            selectedWatchlist = watchlist;
        }
    }
    return selectedWatchlist;
}

-(void)displayWatchList:(TTWatchlist *)selectedWatchlist{
    self.currentDisplayedWatchlist = selectedWatchlist;
    self.watchlistNameLabel.text = selectedWatchlist.watchListName;
    NSString *relativePathString = [NSString stringWithFormat:@"/%d/%@",selectedWatchlist.watchlistID,selectedWatchlist.isSystemWatchlist];
    
    //Update the user defaults...
    //[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:selectedWatchlist.watchlistID] forKey:@"LastSeenWatchlist"];
    
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    [networkManager makeGETRequestWithRelativePath:[[TTUrl watchListURL] stringByAppendingString:relativePathString] responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
        NSLog(@"%@ and status code is %@",jsonString,response);
        
        SBITradingUtility *utilityObj = [SBITradingUtility sharedUtility];
        utilityObj.currentSelectedWatchlist = selectedWatchlist;
        
        NSError *jsonParsingError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        NSArray *rawDataArray = [responseDictionary valueForKey:@"instumentVOList"];
        selectedWatchlist.symbolsArray = rawDataArray;
        //subscribe the symbols recieved...
        [self loadWatchlist:selectedWatchlist With:rawDataArray];
    }];
    
}

-(void)getFirstWatchListWithId{
    
    TTWatchlist *selectedWatchlist = [self.watchListArray objectAtIndex:0];
    SBITradingUtility *utilityObj = [SBITradingUtility sharedUtility];
    utilityObj.currentSelectedWatchlist = selectedWatchlist;
    [self displayWatchList:selectedWatchlist];
    
}

-(void)getWatchlistByid:(int)watchlistID{
    [self displayWatchList:[self returnWatchListById:watchlistID]];
}

-(void)loadWatchlist:(TTWatchlist *)inWatchlist With:(NSArray *)rawDataArray{
    
    TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
    //unsubscribe the previous symbols...
    
//    for(TTDiffusionData *diffusionData in self.symbolListArray){
//        [diffusionHandler unsubscribe:diffusionData.symbolData.subscriptionKey withContext:self];
//    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:inWatchlist.watchlistID] forKey:@"LastSeenWatchlist"];
    inWatchlist.symbolsArray = rawDataArray;
    self.symbolListArray = [[NSMutableArray alloc] init];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self reloadTable];
//    });
    
    for(NSDictionary *symbol in rawDataArray){
        if(symbol != [NSNull null]){
            TTSymbolData *symbolData = [[TTSymbolData alloc] initWithDictionary:symbol];
            TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
            symbolData.jsonRawDictionary = symbol;
            diffusionData.symbolData = symbolData;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [diffusionHandler subscribe:symbolData.subscriptionKey withContext:self];
            
//            });
            [self.symbolListArray addObject:diffusionData];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self prepareSymbolCellMappingDictionary];
        [self reloadTable];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(refreshSymbolData) userInfo:nil repeats:NO];
    });

    //    if([self.currentDisplayedWatchlist.isSystemWatchlist isEqualToString:@"true"])
    //        [self.symbolListTableView setEditing:NO];
    //    else
    //        [self.symbolListTableView setEditing:YES];
    
}

-(void)refreshSymbolData{
    TTDiffusionHandler *diffHandler = [TTDiffusionHandler sharedDiffusionManager];
    for(TTDiffusionData *diffusionData in self.symbolListArray)
        [diffHandler subscribe:diffusionData.symbolData.subscriptionKey withContext:self];
}

-(void)reloadTable{
    [self.symbolListTableView1 reloadData];
    [self.symbolListTableView2 reloadData];
}

#pragma IBAction Delegates

-(IBAction)closeTheOptionMenu:(id)sender{
    //    [_optionsViewController dismissViewControllerAnimated:YES completion:nil];
    [self dismissPopOver];
}

-(IBAction)showWatchList:(id)sender{
    //show all watchlists...
    TTWatchlistEntryViewController *watchListViewController = [[TTWatchlistEntryViewController alloc] initWithNibName:@"TTWatchlistEntryViewController" bundle:nil];
    watchlistEntryNavigationController = [[UINavigationController alloc] initWithRootViewController:watchListViewController];
    watchListViewController.loadWatchlistDelegate = self;
    watchListViewController.parentController = self;
    watchListViewController.isCalledFromOtherScreen = NO;
    watchlistEntryNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:watchlistEntryNavigationController animated:YES completion:nil];
}

-(IBAction)editWatchlist:(id)sender{
    
    if([self.currentDisplayedWatchlist.isSystemWatchlist isEqualToString:@"false"]){
        if(!_editWatchListVieController)
            _editWatchListVieController = [[TTCreateWatchListViewController alloc] initWithNibName:@"TTCreateWatchListViewController" bundle:nil];
        
        _editWatchListVieController.recievedWatchlistObj = nil;
        _editWatchListVieController.refreshWatchListDelegate = self;
        _editWatchListVieController.watchListMode = eSymbolEditableMode;
        _editWatchListVieController.recievedWatchlistObj = self.currentDisplayedWatchlist;
        _editWatchListVieController.shoulUpdateSymbols = YES;
        _editWatchListVieController.navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        if(self.navigationController != NULL){
            _editWatchListVieController.shouldShowBackButton = YES;
            [self.navigationController pushViewController:_editWatchListVieController animated:YES];
        }
        else{
            _editWatchListVieController.shouldShowBackButton = NO;
            [self presentViewController:_editWatchListVieController.navigationController animated:YES completion:nil];
        }
        _editWatchListVieController.title =  NSLocalizedStringFromTable(@"Add_Symbols", @"Localizable", @"Add Symbols");
    }
    else{
        TTAlertView *alertView = [TTAlertView sharedAlert];
        [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"SystemWatchlist_Edit", @"Localizable", :@"System watchlists can't be edited")];
    }
}

-(void)prepareSymbolCellMappingDictionary{
    int i = 0;
    for(TTDiffusionData *currentDiffusionSymbolData in self.symbolListArray){
        if(![[self.symbolCellMapping allKeys] containsObject:currentDiffusionSymbolData.symbolData.subscriptionKey]){
            [self.symbolCellMapping setValue:[NSIndexPath indexPathForRow:i inSection:0] forKey:currentDiffusionSymbolData.symbolData.subscriptionKey];
            i++;
        }
    }
}

-(void)configureCell:(TTWatchlistSymbolTableCell *)cell withIndex:(NSIndexPath *)indexPath{
    TTDiffusionData *currentDiffusionSymbolData = [self.symbolListArray objectAtIndex:indexPath.row];
//    if(![[self.symbolCellMapping allKeys] containsObject:currentDiffusionSymbolData.symbolData.subscriptionKey])
//        [self.symbolCellMapping setValue:indexPath forKey:currentDiffusionSymbolData.symbolData.subscriptionKey];
    if(indexPath.row % 2 == 0){
        //set background color of the cell to white...
        cell.backgroundColor = [UIColor whiteColor];
    }
    else{
        //set background color of the cell to gray...
        cell.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    }
    cell.difusionData = currentDiffusionSymbolData;
    cell.companyNameLabel.text = currentDiffusionSymbolData.symbolData.companyName;
    [cell.symbolName setTitle:currentDiffusionSymbolData.symbolData.tradeSymbolName forState:UIControlStateNormal];
    cell.volumeLabel.text = [NSString stringWithFormat:@"%.02f",currentDiffusionSymbolData.volume];
    cell.dayRangeLabel.text = [NSString stringWithFormat:@"%.02f - %.02f",currentDiffusionSymbolData.lowPrice,currentDiffusionSymbolData.highPrice];
    cell.fiftyTwoWeekRangeLabel.text = [NSString stringWithFormat:@"%.02f - %.02f",currentDiffusionSymbolData.fiftyTwoWeekLow,currentDiffusionSymbolData.fiftyTwoWeekHigh];
    //price indicator dependent labels...
    
    cell.bidLabel.text = [NSString stringWithFormat:@"%.02f",currentDiffusionSymbolData.bidValue];
    cell.askLabel.text = [NSString stringWithFormat:@"%.02f",currentDiffusionSymbolData.askValue];
    cell.closeLabel.text = [NSString stringWithFormat:@"%.02f",currentDiffusionSymbolData.closingPrice];
    float priceChange = currentDiffusionSymbolData.lastSalePrice-currentDiffusionSymbolData.closingPrice;
    
    if([currentDiffusionSymbolData.netPriceChangeIndicator isEqualToString:@""])
        currentDiffusionSymbolData.netPriceChangeIndicator = GET_SIGN_INDICATOR(priceChange);
    
    if([currentDiffusionSymbolData.netPriceChangeIndicator isEqualToString:@"+"]){
//        cell.bidLabel.textColor = cell.askLabel.textColor = cell.changeLabel.textColor = cell.lastTradeLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:166.0/255.0 blue:2.0/255.0 alpha:1];
        cell.changeLabel.textColor = cell.lastTradeLabel.textColor = SYMBOL_PROFIT_LABEL_COLOR;
        
    }
    else{
      //  cell.bidLabel.textColor = cell.askLabel.textColor = cell.changeLabel.textColor = cell.lastTradeLabel.textColor = [UIColor colorWithRed:228.0/255.0 green:72.0/255.0 blue:50.0/255.0 alpha:1];
        cell.changeLabel.textColor = cell.lastTradeLabel.textColor = SYMBOL_LOSS_LABEL_COLOR;
    }
    

    float percentage = 0.00;
    if(currentDiffusionSymbolData.closingPrice != 0)
        percentage = (fabsf(priceChange)/currentDiffusionSymbolData.closingPrice)*100;
    if(isnan(percentage)){
        percentage = 0.00;
    }
    cell.changeLabel.text = [NSString stringWithFormat:@"%@%.02f(%@%.02f%%)",currentDiffusionSymbolData.netPriceChangeIndicator,fabsf(priceChange),currentDiffusionSymbolData.netPriceChangeIndicator,percentage];
    cell.lastTradeLabel.text = [NSString stringWithFormat:@"%.02f",currentDiffusionSymbolData.lastSalePrice];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1000){
        if(buttonIndex == 0){
            //delete the symbol...
            [self deleteTheSymbol];
            
        }
        else{
            NSLog(@"Do nothing !!");
        }
    }
}

-(void)deleteTheSymbol{
    int index = self.indexPathToBeDeleted.row;
    //delete this object from the array...
    TTDiffusionData *toDeleteSymbol = [self.symbolListArray objectAtIndex:index];
    [self deleteSymbolFromWatchlist:toDeleteSymbol.symbolData.jsonRawDictionary];
    [self.symbolListArray removeObjectAtIndex:index];
    [self.symbolListTableView1 deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathToBeDeleted] withRowAnimation:UITableViewRowAnimationRight];
    [self.symbolListTableView2 deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathToBeDeleted] withRowAnimation:UITableViewRowAnimationRight];
    [self reloadTable];
}

#pragma TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    if([self.currentDisplayedWatchlist.isSystemWatchlist isEqualToString:@"false"])
//        return YES;
//    else
        return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _symbolListTableView2 || tableView == _symbolListTableView1)
        return 70;
    else
        return 35;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _symbolListTableView2 || tableView == _symbolListTableView1)
        return [self.symbolListArray count];
    else
        return [_optionMenuArray count];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    UITableView *slaveTable = nil;
    
    if (_symbolListTableView1 == scrollView) {
        slaveTable = _symbolListTableView2;
    } else if (_symbolListTableView2 == scrollView) {
        slaveTable = _symbolListTableView1;
    }
    
    [slaveTable setContentOffset:scrollView.contentOffset];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _symbolListTableView1){
        static NSString *cellIdentifier = @"SymbolTableCell";
        TTWatchlistSymbolTableCell *cell = nil;
        
        if (cell == nil) {
            cell = (TTWatchlistSymbolTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTWatchlistSymbolTableCell" owner:self options:nil];
            
            for(id oneObject in nib) {
                
                if([oneObject isKindOfClass:[TTWatchlistSymbolTableCell class]]) {
                    
                    cell = (TTWatchlistSymbolTableCell *)oneObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.watchlistColumnsArray = _watchlistVisibleColumnsArray;
                    cell.watchListCellDelegate = self;
                    
                }
                
            }
            
        }
        [self configureCell:cell withIndex:indexPath];
        
        return cell;
    }
    else if(tableView == _symbolListTableView2){
        static NSString *cellIdentifier = @"SymbolDetailCell";
        TTWatchlistSymbolTableCell *cell = nil;
        
        if (cell == nil) {
            cell = (TTWatchlistSymbolTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTWatchlistSymbolDetailTableCell" owner:self options:nil];
            
            for(id oneObject in nib) {
                
                if([oneObject isKindOfClass:[TTWatchlistSymbolTableCell class]]) {
                    
                    cell = (TTWatchlistSymbolTableCell *)oneObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.watchlistColumnsArray = _watchlistVisibleColumnsArray;
                    cell.watchListCellDelegate = self;
                    
                }
                
            }
            
        }
        [self configureCell:cell withIndex:indexPath];
        
        return cell;
        
    }
    else {
        static NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = [_optionMenuArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:11.0];
        cell.textLabel.textColor = [UIColor blackColor];
        if(![self.currentDisplayedWatchlist.isSystemWatchlist isEqualToString:@"false"]){
            NSLog(@"Before Index path is %d",indexPath.row);
            if(indexPath.row == eDeleteSymbolAction){
                NSLog(@"Index path is %d",indexPath.row);
                cell.textLabel.textColor = [UIColor lightGrayColor];
            }
        }
        TTWatchlistSymbolTableCell *currentCell = (TTWatchlistSymbolTableCell *)[_symbolListTableView1 cellForRowAtIndexPath:self.indexPathToBeDeleted];
        if(![currentCell.difusionData.symbolData.instrumentType hasPrefix:@"OPT"]){
            if(indexPath.row == eOptionChainAction)
                cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    TTWatchlistSymbolTableCell *currentCell = (TTWatchlistSymbolTableCell *)cell;
//    currentCell.symbolName.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:143.0/255.0 blue:223.0/255.0 alpha:1];
//}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _symbolListTableView2 || tableView == _symbolListTableView1){
        TTWatchlistSymbolTableCell *currentCell = (TTWatchlistSymbolTableCell *)[tableView cellForRowAtIndexPath:indexPath];
        currentCell.symbolName.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:143.0/255.0 blue:223.0/255.0 alpha:1];
    }
}


//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    TTWatchlistSymbolTableCell *currentCell = (TTWatchlistSymbolTableCell *)[tableView cellForRowAtIndexPath:indexPath];
//    currentCell.symbolName.backgroundColor = [UIColor redColor];//[UIColor colorWithRed:59.0/255.0 green:143.0/255.0 blue:223.0/255.0 alpha:1];
//    return indexPath;
//}

-(void)showTradeScreen:(TTWatchlistSymbolTableCell *)inCell{
    TTSymbolDetails *globalSymbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    globalSymbolDetails.symbolData = inCell.difusionData.symbolData;
    NSLog(@"Selected symbol is %@",globalSymbolDetails.symbolData.symbolName);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGlobalSymbol" object:nil];
    
    //present the Trade screen ...
    
    self.tradeViewController = [[TTTradePopoverController alloc] initWithNibName:@"TTTradePopoverController" bundle:nil];
    self.tradeViewController.isModifyMode = NO;
    _tradeViewController.delegate = self;
    self.tradeViewNavigationController = [[TTCustomViewController alloc] initWithRootViewController:self.tradeViewController];
    [self.watchlistDelegate presntTradeView:self.tradeViewNavigationController];
}

-(void)showQuoteScreen:(NSIndexPath *)indexPath{
    TTDiffusionData *currentSelectedDiffusion = [self.symbolListArray objectAtIndex:indexPath.row];
    
    //update the global symbol ...
    
    TTSymbolDetails *globalSymbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    globalSymbolDetails.symbolData = currentSelectedDiffusion.symbolData;
    NSLog(@"Selected symbol is %@",globalSymbolDetails.symbolData.symbolName);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGlobalSymbol" object:nil];
    
    //present the Quotes screen ...
    
    self.quotesViewController = [[TTQuotesViewController alloc] initWithNibName:@"TTQuotesViewController" bundle:nil];
    self.quotesViewNavigationController = [[TTCustomViewController alloc] initWithRootViewController:self.quotesViewController];
    [self.watchlistDelegate presntQuotesView:self.quotesViewNavigationController];
}

-(void)deleteWatchlistSymbol{
    UIAlertView *confirmDeleteAlertView = [[UIAlertView alloc] initWithTitle:@"Symbol Deletion" message:@"Do you want to delete the selected symbol" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    confirmDeleteAlertView.tag = 1000;
    [confirmDeleteAlertView show];
}

-(void)showOptionChain:(TTWatchlistSymbolTableCell *)inCell{
    //check if the symbol is of type Option ...
    //    if(inCell.difusionData.instrumentType == OPTION_STOCK || inCell.difusionData.instrumentType == OPTION_INDEX || inCell.difusionData.instrumentType == OPTION_CURRENCY){
    
    TTSymbolDetails *globalSymbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    globalSymbolDetails.symbolData = inCell.difusionData.symbolData;
    NSLog(@"Selected symbol is %@",globalSymbolDetails.symbolData.symbolName);
    
    _optionChainViewController = [[TTOptionChainViewController alloc] initWithNibName:@"TTOptionChainViewController" bundle:nil];
    _optionChainViewController.isVisitedFromOtherScreen = YES;
    _optionChainViewController.isEnlargedView = YES;
    _optionChainViewController.currentSymbol = globalSymbolDetails.symbolData;
    UINavigationController *optionChainNavigationController = [[TTCustomViewController alloc] initWithRootViewController:_optionChainViewController];
    [self.watchlistDelegate presntQuotesView:optionChainNavigationController];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGlobalSymbol" object:nil];
    
    //    }
    
}

//[self.currentDisplayedWatchlist.isSystemWatchlist isEqualToString:@"false"]

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _optionMenuTableView){
        
        UITableViewCell *currentActionCell = (UITableViewCell *)[_optionMenuTableView cellForRowAtIndexPath:indexPath];
        
        TTWatchlistSymbolTableCell *currentCell = (TTWatchlistSymbolTableCell *)[_symbolListTableView1 cellForRowAtIndexPath:self.indexPathToBeDeleted];
        
        // get the action item ...
        switch (indexPath.row) {
            case 0:
                //Trade ...
                [self showTradeScreen:currentCell];
                [self dismissPopOver];
                break;
            case 1:
                //Quote ...
                [self showQuoteScreen:self.indexPathToBeDeleted];
                [self dismissPopOver];
                break;
//            case 2:
//                //Add Symbol ...
//                if([self.currentDisplayedWatchlist.isSystemWatchlist isEqualToString:@"false"]){
//                    [self editWatchlist:nil];
//                    [self dismissPopOver];
//                }
//                break;
            case 2:
                //Delete Symbol ...
                if([self.currentDisplayedWatchlist.isSystemWatchlist isEqualToString:@"false"]){
                    [self deleteWatchlistSymbol];
                    [self dismissPopOver];
                }
                break;
            case 3:
                //Option Chain ...
                if([currentCell.difusionData.symbolData.instrumentType hasPrefix:@"OPT"]){
                    [self showOptionChain:currentCell];
                    [self dismissPopOver];
                }
                break;
            default:
                break;
        }
        currentActionCell.backgroundColor = [UIColor whiteColor];
    }
    
    
    //    TTDiffusionData *currentSelectedDiffusion = [self.symbolListArray objectAtIndex:indexPath.row];
    //
    ////    [self.updateUIDelegate updateSearchText:currentSelectedSymbol.symbolData.symbolName];
    ////    [self.updateUIDelegate didCallDismissPopOver];
    //
    //    //update the global symbol ...
    //
    //    TTSymbolDetails *globalSymbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    //    globalSymbolDetails.symbolData = currentSelectedDiffusion.symbolData;
    //    NSLog(@"Selected symbol is %@",globalSymbolDetails.symbolData.symbolName);
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGlobalSymbol" object:nil];
    //
    //    //present the Quotes screen ...
    //
    //    self.quotesViewController = [[TTQuotesViewController alloc] initWithNibName:@"TTQuotesViewController" bundle:nil];
    ////    self.quotesViewNavigationController = [[UINavigationController alloc] initWithRootViewController:self.quotesViewController];
    //    self.quotesViewNavigationController = [[TTCustomViewController alloc] initWithRootViewController:self.quotesViewController];
    //    [self.watchlistDelegate presntQuotesView:self.quotesViewNavigationController];
    //    [self presentViewController:self.quotesViewController animated:YES completion:nil];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (editingStyle == UITableViewCellEditingStyleDelete) {
    //
    //        self.indexPathToBeDeleted = indexPath;
    //
    //        UIAlertView *confirmDeleteAlertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Do you want to delete the selected symbol" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    //        [confirmDeleteAlertView show];
    //
    //    }
}

-(void)deleteSymbolFromWatchlist:(NSDictionary *)jsonDictionary{
    
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    NSString *relativePath = [NSString stringWithFormat:@"%@/%d/symbollist",[TTUrl watchListURL],self.currentDisplayedWatchlist.watchlistID];
    
    //    NSArray *postBodyArray = [NSArray arrayWithObject:jsonDictionary];
    //    NSError *error;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postBodyArray options:NSJSONWritingPrettyPrinted error:&error];
    //    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSArray *postBodyArray = [NSArray arrayWithObject:jsonDictionary];
    
    [networkManager makeDELETERequestWithRelativePath:relativePath withPostBody:postBodyArray responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        NSLog(@"Delete symbol response is %@",response);
    }];
}

#pragma CreateWatchListViewController Delegates

- (void) createWatchListViewControllerdidReferesh:(TTCreateWatchListViewController *)inController forWatchListId:(int)inWatchlistId
{
    
//    if(self.currentDisplayedWatchlist.watchlistID == inWatchlistId){
        //update the symbol list of the watchlist ...
        if(inController.tempWatchlist != nil)
            [self displayWatchList:inController.tempWatchlist];
        else{
            [self getWatchlistByid:inWatchlistId];
           // [self displayWatchList:self.currentDisplayedWatchlist];
        }
//    }

}
- (void) createWatchListViewControllerdidCancel:(TTCreateWatchListViewController *)inController
{
    [inController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma delegates

-(void)didSelectTradeButton:(TTWatchlistSymbolTableCell *)inCell{
    [self showTradeScreen:inCell];
}


- (void)tradePopoverControllerDidPlaceTradeSuccessfully:(TTTradePopoverController *)inController  shouldShowOrders:(BOOL)showOrder
{

    [self.navigationController popToRootViewControllerAnimated:NO];
    
    if(showOrder)
        [self performSelector:@selector(showOrder) withObject:nil afterDelay:0.5];
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
