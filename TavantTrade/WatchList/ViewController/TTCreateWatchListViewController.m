//
//  TTCreateWatchListViewController.m
//  TavantTrade
//
//  Created by Gautham S Shetty on 24/01/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTCreateWatchListViewController.h"
#import "TTDiffusionData.h"
#import "SBITradingNetworkManager.h"
#import "SBITradingUtility.h"
#import "TTGlobalSymbolSearchViewController.h"
#import "TTAlertView.h"
#import "TTUrl.h"

@interface TTCreateWatchListViewController ()
@property (nonatomic, weak) IBOutlet UITableView *symbolTableView;
@property (nonatomic, weak) IBOutlet UITextField *txtWatchlistName;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UIButton *btnSymbolSearch;
@property(nonatomic,strong)NSIndexPath *indexPathToBeDeleted;
@property(nonatomic,weak)IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property(nonatomic,weak)IBOutlet UIView *headerView;
@property(nonatomic,strong)NSMutableDictionary *initialDictionary;
@property(nonatomic,strong)NSMutableArray *symbolsArray;
@property(nonatomic,strong)NSMutableArray *newlyAddedsymbolArray;
@property(nonatomic, strong) TTGlobalSymbolSearchViewController *searchViewController;
@property(nonatomic, strong) UINavigationController *mainNavigationController;

@end

@implementation TTCreateWatchListViewController
@synthesize lblTitle = _lblTitle;
@synthesize txtWatchlistName = _txtWatchlistName;
@synthesize symbolTableView = _symbolTableView;
@synthesize btnSymbolSearch = _btnSymbolSearch;
@synthesize  searchViewController = _searchViewController;
@synthesize refreshWatchListDelegate = _refreshWatchListDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _mainNavigationController = [[UINavigationController alloc] initWithRootViewController:self];
        _mainNavigationController.navigationBarHidden = YES;
        _shoulUpdateSymbols = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.symbolsArray = [[NSMutableArray alloc] init];
    
    self.initialDictionary = [[NSMutableDictionary alloc] init];
    self.newlyAddedsymbolArray = [[NSMutableArray alloc] init];
    
    _symbolTableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _symbolTableView.layer.borderWidth = 0.5;
    _symbolTableView.layer.cornerRadius = 2.0;
    
    _txtWatchlistName.enabled = YES;
    _btnSymbolSearch.enabled = YES;
    
    //set the button title ...
    [_cancelButton setTitle:NSLocalizedStringFromTable(@"Cancel_Button_Title", @"Localizable", @"Cancel") forState:UIControlStateNormal];
    [_doneButton setTitle:NSLocalizedStringFromTable(@"Done_Button_Title", @"Localizable", @"Done") forState:UIControlStateNormal];
    
    _lblTitle.font = SEMI_BOLD_FONT_SIZE(22.0);
    _txtWatchlistName.font = REGULAR_FONT_SIZE(15.0);
    
    if(self.shouldShowBackButton)
        [self.cancelButton setTitle:@"Back" forState:UIControlStateNormal];
    else
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
     _cancelButton.titleLabel.font = _doneButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);
    
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"Default"];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.view.superview.backgroundColor = [UIColor clearColor];
    switch (self.watchListMode) {
        case eDefaultMode:
        {
            _txtWatchlistName.enabled = NO;
            _btnSymbolSearch.enabled = NO;
        }
            break;
        case eCreateMode:
        {
//            _txtWatchlistName.text = @"";
            _txtWatchlistName.enabled = YES;
            _txtWatchlistName.borderStyle = UITextBorderStyleRoundedRect;
            _lblTitle.text = NSLocalizedStringFromTable(@"Create_WatchList", @"Localizable", @"Create WatchList");
        }
            break;
        case eSymbolEditableMode:
        {
            _txtWatchlistName.text = _recievedWatchlistObj.watchListName;
            //_lblTitle.text = _recievedWatchlistObj.watchListName;
            _txtWatchlistName.hidden = NO;
            _txtWatchlistName.borderStyle = UITextBorderStyleNone;
            _txtWatchlistName.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:230.0/255.0 blue:233.0/255.0 alpha:1];
            _lblTitle.text = NSLocalizedStringFromTable(@"Add_Symbol", @"Localizable", @"Add Symbol");
            
        }
            break;
        case eWatchlistEditableMode:
        {
            _txtWatchlistName.text = _recievedWatchlistObj.watchListName;
            _txtWatchlistName.enabled = YES;
            _txtWatchlistName.borderStyle = UITextBorderStyleRoundedRect;
            _lblTitle.text = NSLocalizedStringFromTable(@"Edit_WatchList", @"Localizable", @"Edit WatchList");
            
        }
            break;
            
        default:
            break;
    }
    
    
    if(_shoulUpdateSymbols)
    {
        NSString *relativePathString = [NSString stringWithFormat:@"/%d/%@",self.recievedWatchlistObj.watchlistID,self.recievedWatchlistObj.isSystemWatchlist];
        
        SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
        [networkManager makeGETRequestWithRelativePath:[[TTUrl watchListURL] stringByAppendingString:relativePathString] responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
            
            NSError *jsonParsingError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            NSArray *rawDataArray = [responseDictionary valueForKey:@"instumentVOList"];
            [self.symbolsArray removeAllObjects];
            self.recievedWatchlistObj.symbolsArray = rawDataArray;
            for(NSDictionary *symbol in rawDataArray){
                if(symbol != [NSNull null]){
                    TTSymbolData *symbolData = [[TTSymbolData alloc] initWithDictionary:symbol];
                    
                    symbolData.jsonRawDictionary = symbol;
                    
                    TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
                    diffusionData.symbolData = symbolData;
                    [self.symbolsArray addObject:diffusionData];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_symbolTableView reloadData];
            });
            
            //update the initial dictionary with the server recieved values...
            
            NSArray *array = [NSArray arrayWithArray:self.symbolsArray];
            
            [self.initialDictionary setValue:self.txtWatchlistName.text forKey:@"watchlistName"];
            [self.initialDictionary setValue:array forKey:@"symbolSet"];
            
        }];
        _shoulUpdateSymbols = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.navigationController.view.bounds = CGRectMake(0, 0, 428, 506);
}

- (IBAction)performSymbolSearch:(id)sender
{
    if(!_searchViewController)
    {
        _searchViewController = [[TTGlobalSymbolSearchViewController alloc] initWithNibName:@"TTGlobalSymbolSearchViewController" bundle:nil];
        _searchViewController.searchType = eDefault;
        _searchViewController.shouldShowBackButton=YES;
        _searchViewController.previousScreenTitle=@"Edit";
        _searchViewController.delegate = self;
    }
    
    NSLog(@"%@", self.navigationController.viewControllers);
    
    NSLog(@" Navigation Controller = %@", self.navigationController);
    
    [self.navigationController pushViewController:_searchViewController animated:YES];
}


#pragma TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.symbolsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    TTDiffusionData *currentDiffusionSymbolData = [self.symbolsArray objectAtIndex:indexPath.row];
    NSLog(@"symbolarray is %@",self.symbolsArray);
    cell.textLabel.text = currentDiffusionSymbolData.symbolData.tradeSymbolName;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = REGULAR_FONT_SIZE(15.0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
    //delete this object from the array...
    int index = self.indexPathToBeDeleted.row;
    TTDiffusionData *toDeleteSymbol = [self.symbolsArray objectAtIndex:index];
    
    if([self.newlyAddedsymbolArray containsObject:toDeleteSymbol]){
        //this symbol is not added to the main watchlist object yet...
        //Remove it only from the local array...
        
        [self.newlyAddedsymbolArray removeObject:toDeleteSymbol];
        [self.symbolsArray removeObject:toDeleteSymbol];
        
    }
    else{
        [self deleteSymbolFromWatchlist:toDeleteSymbol.symbolData.jsonRawDictionary];
        [self.symbolsArray removeObjectAtIndex:index];
    }
    
    [_symbolTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathToBeDeleted] withRowAnimation:UITableViewRowAnimationRight];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        self.indexPathToBeDeleted = indexPath;
        
        //confirmation before delete...
        
        UIAlertView *confirmDeleteAlertView = [[UIAlertView alloc] initWithTitle:@"Symbol Deletion" message:@"Do you want to delete the selected symbol" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        confirmDeleteAlertView.tag = 1000;
        [confirmDeleteAlertView show];
        
    }
}

-(void)deleteSymbolFromWatchlist:(NSDictionary *)jsonDictionary{
    
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    NSString *relativePath = [NSString stringWithFormat:@"%@/%d/symbollist",[TTUrl watchListURL],self.recievedWatchlistObj.watchlistID];
    
//     NSArray *postBodyArray = [NSArray arrayWithObject:jsonDictionary];
//     NSError *error;
//     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postBodyArray options:NSJSONWritingPrettyPrinted error:&error];
//     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSArray *postBodyArray = [NSArray arrayWithObject:jsonDictionary];
    [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:postBodyArray responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        NSLog(@"Delete symbol response is %@",response);
    }];
}


-(IBAction)cancelAction:(id)sender
{
    if(self.shouldShowBackButton){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        if(_refreshWatchListDelegate && [_refreshWatchListDelegate respondsToSelector:@selector(createWatchListViewControllerdidCancel:)])
        {
            [_refreshWatchListDelegate createWatchListViewControllerdidCancel:self];
        }
    }

}

-(IBAction)doneAction:(id)sender
{
    
    if([self.txtWatchlistName.text length] > 0  && (![[self.initialDictionary valueForKey:@"watchlistName"] isEqualToString:self.txtWatchlistName.text] || ![[self.initialDictionary valueForKey:@"symbolSet"]isEqualToArray:self.symbolsArray] )){
        
        if(self.watchListMode == eWatchlistEditableMode || self.watchListMode == eSymbolEditableMode){
            NSString *relativePath = [NSString stringWithFormat:@"watchlists/%d/%@",self.recievedWatchlistObj.watchlistID,self.txtWatchlistName.text];
            NSLog(@"Relative path is %@",relativePath);
            
            SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
            [networkManager makePUTRequestWithRelativePath:relativePath withBody:nil responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
                
                NSError *jsonParsingError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
                NSLog(@"Response dictionary is %@",responseDictionary);
                
                NSString *watchlistID = [responseDictionary valueForKey:@"id"];
                _tempWatchlist = self.recievedWatchlistObj;
                _tempWatchlist.watchListName = responseDictionary[@"name"];
                _tempWatchlist.watchlistID = [watchlistID intValue];
                
                NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
                if(recievedResponse.statusCode == 200){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        TTAlertView *alertView = [TTAlertView sharedAlert];
                        [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Watchlist_Edit", @"Localizable", @"Watchlist edited successfully")];
                    });
                    
                    if([self.newlyAddedsymbolArray count] > 0){
                        //send a request to the server with the current watchlist id and the set of newly added symbols...
                        [self sendTheSymbolsFowWatchlistWithID:[watchlistID intValue]];
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self dismissViewControllerAnimated:YES completion:^{
                                int watchlistId = [watchlistID intValue];
                                if(_refreshWatchListDelegate && [_refreshWatchListDelegate respondsToSelector:@selector(createWatchListViewControllerdidReferesh:forWatchListId:)])
                                {
                                    [_refreshWatchListDelegate createWatchListViewControllerdidReferesh:self forWatchListId:watchlistId];
                                }
                            }];
                        });
                        
                    }
                }

            }];
        }
        
        else{
            //send a request to the server with the watchlist name...
            NSString *relativePath = [NSString stringWithFormat:@"watchlists/%@",self.txtWatchlistName.text];
            
            SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
            __block NSString *watchlistID = @"";
            [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:nil responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
                
                NSError *jsonParsingError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
                NSLog(@"Dict is %@",responseDictionary);
                watchlistID = [responseDictionary valueForKey:@"id"];
                _tempWatchlist = [[TTWatchlist alloc] init];
                _tempWatchlist.watchListName = responseDictionary[@"name"];
                _tempWatchlist.watchlistID = [watchlistID intValue];
                _tempWatchlist.isDefaultWatchlist = ([[responseDictionary valueForKey:@"isDefaultMarketWatch"] intValue] == 1)?@"true":@"false";
                _tempWatchlist.isSystemWatchlist = ([[responseDictionary valueForKey:@"isSystemMarketWatch"] intValue] == 1)?@"true":@"false";
                //show a pop up with confirmation..
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    TTAlertView *alertView = [TTAlertView sharedAlert];
                    [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Watchlist_Create", @"Localizable", @"Watchlist created successfully")];
                    //[self dismissViewControllerAnimated:YES completion:nil];
                });
                
                if([self.newlyAddedsymbolArray count] > 0){
                    //send a request to the server with the current watchlist id and the set of newly added symbols...
                    [self sendTheSymbolsFowWatchlistWithID:[watchlistID intValue]];
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:^{
                            int watchlistId = [watchlistID intValue];
                            if(_refreshWatchListDelegate && [_refreshWatchListDelegate respondsToSelector:@selector(createWatchListViewControllerdidReferesh:forWatchListId:)])
                            {
                                [_refreshWatchListDelegate createWatchListViewControllerdidReferesh:self forWatchListId:watchlistId];
                            }
                        }];
                    });
                    
                }

            }];
        }
        
        //load this watchlist in the dashboard ...
        
        
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
-(void)sendTheSymbolsFowWatchlistWithID:(int)watchlistID{
    NSString *relativePath = [NSString stringWithFormat:@"watchlists/%d/symbols",watchlistID];
    
    //make the POST body...
    
    //access raw json dictionary from the array...
//    NSMutableArray *symbolArray = [[NSMutableArray alloc] init];
    for(TTDiffusionData *data in self.newlyAddedsymbolArray){
        //        [symbolArray addObject:data.symbolData.jsonRawDictionary];
        //convert nsdictionary object to JSON String...
        //        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:symbolArray options:0 error:nil];
        //        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        //    NSLog(@"json string is %@ and %@",jsonString,symbolArray);
        SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
        
        NSArray *postBodyArray = [NSArray arrayWithObject:data.symbolData.jsonRawDictionary];
        
        [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:postBodyArray responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
            
            NSError *jsonParsingError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            NSLog(@"Dict is %@",responseDictionary);
//            _tempWatchlist = self.recievedWatchlistObj;
//            _tempWatchlist.watchListName = responseDictionary[@"name"];
//            _tempWatchlist.watchlistID = watchlistID;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{
                    [_refreshWatchListDelegate createWatchListViewControllerdidReferesh:self forWatchListId:watchlistID];
                    self.newlyAddedsymbolArray = [[NSMutableArray alloc] init];
                }];
                
            });
            
        }];
    }
    
}

- (void) globalSymbolSearchViewControllerDidCancelSearch:(TTGlobalSymbolSearchViewController *)inController
{
//    [_mainNavigationController popToViewController:self animated:YES];
    NSLog(@"main nav controller is %@",_mainNavigationController);
        NSLog(@"self nav controller is %@",self.navigationController.viewControllers);
    [_mainNavigationController popViewControllerAnimated:YES];
}

- (void) globalSymbolSearchViewController:(TTGlobalSymbolSearchViewController *)inController didSelectSymbol:(TTSymbolData *)inSymbol
{
    TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
    diffusionData.symbolData = inSymbol;
    
    //check if the symbol already exists in the watchlist...
    
    BOOL doesSymbolExist = NO;
    
    for(TTDiffusionData *data in self.symbolsArray){
        if([data.symbolData.subscriptionKey isEqualToString:diffusionData.symbolData.subscriptionKey]){
            doesSymbolExist = YES;
            break;
        }
    }
    
    if(doesSymbolExist){
        TTAlertView *alertView = [TTAlertView sharedAlert];
        [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Symbol_Exists", @"Localizable", @"Symbol already exists in the Watchlist")];
    }
    else{
        //add the selected symbol instrument to the list...
        [self.newlyAddedsymbolArray addObject:diffusionData];
        [self.symbolsArray addObject:diffusionData];
        [_symbolTableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

@end
