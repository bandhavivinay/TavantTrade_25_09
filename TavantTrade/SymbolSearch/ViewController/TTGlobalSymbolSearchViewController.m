//
//  TTGlobalSymbolSearchViewController.m
//  TavantTrade
//
//  Created by Gautham S Shetty on 24/01/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTGlobalSymbolSearchViewController.h"
#import "SBITradingUtility.h"
#import "SBITradingNetworkManager.h"
#import "TTSymbolSearch.h"
#import <QuartzCore/QuartzCore.h>
#import "TTCellData.h"
#import "TTAlertView.h"

@interface TTGlobalSymbolSearchViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnInstrumentType;
@property (weak, nonatomic) IBOutlet UIButton *btnExchangeType;
@property(nonatomic,strong)IBOutlet UIView *popoverView;
@property(nonatomic,weak)IBOutlet UITableView *popOverTableView;
@property(nonatomic,strong)IBOutlet UIView *popoverOptionView;
@property(nonatomic,weak)IBOutlet UITableView *popOverOptionTableView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *symbolsListView;
@property(nonatomic,strong)NSIndexPath *previousIndexPath;
@property(nonatomic,weak)IBOutlet UIView *headerView;
@property(nonatomic,strong)TTSymbolSearch *currentSelectedSymbolSearch;
@property(nonatomic,strong)TTSymbolSearchTableCell *currentSelectedCell;
@property(nonatomic,strong)TTSymbolSearchTableCell *previousSelectedCell;
@property(nonatomic,strong)NSMutableArray *symbolResultArray;
@property(nonatomic,strong)NSMutableArray *optionsArray;
@property (nonatomic, assign) BOOL isInstrumentSelected;
@property(nonatomic,strong)UIPopoverController *selectPopoverController;
@property(nonatomic,assign)InstrumentType currentSelectedInstrument;
@property(nonatomic,strong)NSString *currentSelectedExchange;
@property(nonatomic,assign)BOOL isExpiryDateSelected;
@property(nonatomic,assign)BOOL isOptionTypeSelected;
@property(nonatomic,assign)BOOL isStrikePriceSelected;
@property(nonatomic,strong)NSMutableArray *expiryDateArray;


@end

@implementation TTGlobalSymbolSearchViewController

@synthesize isInstrumentSelected = _isInstrumentSelected;
@synthesize optionsArray = _optionsArray;
@synthesize btnExchangeType = _btnExchangeType;
@synthesize btnInstrumentType = _btnInstrumentType;
@synthesize currentSelectedExchange = _currentSelectedExchange, currentSelectedInstrument = _currentSelectedInstrument;

@synthesize delegate = _delegate;

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
    self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_searchBar becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(_searchType == eDefault){
        _currentSelectedInstrument = EQUITY;
    }
    else{
        _currentSelectedInstrument = OPTION_STOCK;
    }
    [_btnInstrumentType setTitle:[SBITradingUtility getTitleForInstrumentType:_currentSelectedInstrument] forState:UIControlStateNormal];
    _currentSelectedExchange = @"NSE";
    self.symbolsListView.editing = NO;
    self.symbolsListView.layer.borderWidth = 0.25;
    self.symbolsListView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.symbolsListView.layer.cornerRadius = 2.0f;
    
    _searchSymbolTitle.font = SEMI_BOLD_FONT_SIZE(22.0);
    
    //set the screen heading and other button title ...
    [_cancelButton setTitle:NSLocalizedStringFromTable(@"Cancel_Button_Title", @"Localizable", @"Cancel") forState:UIControlStateNormal];
    [_doneButton setTitle:NSLocalizedStringFromTable(@"Done_Button_Title", @"Localizable", @"Done") forState:UIControlStateNormal];
    _searchSymbolTitle.text = NSLocalizedStringFromTable(@"Symbol_Search_Title", @"Localizable", @"Search Symbol");
    
    _btnExchangeType.titleLabel.font = _btnInstrumentType.titleLabel.font = SEMI_BOLD_FONT_SIZE(14.0);
    _cancelButton.titleLabel.font = _doneButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"Default"];
    if(self.shouldShowBackButton){
        [self.cancelButton setTitle:self.previousScreenTitle forState:UIControlStateNormal];
        [self.cancelButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [self.cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-5,0,0)];
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTheOptionsArray:(ESearchType)inOrderType{
    self.optionsArray = [[NSMutableArray alloc] init];
    if(inOrderType == eDefault){
        [self.optionsArray addObject:[SBITradingUtility getTitleForInstrumentType:EQUITY]];
        [self.optionsArray addObject:[SBITradingUtility getTitleForInstrumentType:FUTURE_STOCK]];
        [self.optionsArray addObject:[SBITradingUtility getTitleForInstrumentType:FUTURE_INDEX]];
        [self.optionsArray addObject:[SBITradingUtility getTitleForInstrumentType:FUTURE_CURRENCY]];
    }
    [self.optionsArray addObject:[SBITradingUtility getTitleForInstrumentType:OPTION_STOCK]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForInstrumentType:OPTION_INDEX]];
    [self.optionsArray addObject:[SBITradingUtility getTitleForInstrumentType:OPTION_CURRENCY]];
}

-(void)setTheExchangeArray:(ESearchType)inOrderType{
    self.optionsArray = [[NSMutableArray alloc] init];
    [self.optionsArray addObject:@"NSE"];
    if(inOrderType == eDefault)
        [self.optionsArray addObject:@"BSE"];
}

-(IBAction)selectInstrumentType:(id)sender{
    [self dismissPopOverAndKeyboard];
    _isInstrumentSelected = YES;
    [self setTheOptionsArray:_searchType];
    [self.popOverOptionTableView reloadData];
    UIViewController* controller = [[UIViewController alloc] init];
    controller.view = self.popoverOptionView;
    self.selectPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self.selectPopoverController setPopoverContentSize:CGSizeMake(self.popoverView.frame.size.width, self.popoverView.frame.size.height)];
    [self.selectPopoverController presentPopoverFromRect:[(UIButton *)sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
-(IBAction)selectExchangeType:(id)sender{
    [self dismissPopOverAndKeyboard];
    _isInstrumentSelected = NO;
    [self setTheExchangeArray:_searchType];
    
    [self.popOverOptionTableView reloadData];
    
    UIViewController* controller = [[UIViewController alloc] init];
    controller.view = self.popoverOptionView;
    self.selectPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self.selectPopoverController setPopoverContentSize:CGSizeMake(controller.view.frame.size.width, controller.view.frame.size.height)];
    [self.selectPopoverController presentPopoverFromRect:[(UIButton *)sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(IBAction)cancelAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(globalSymbolSearchViewControllerDidCancelSearch:)])
    {
        NSLog(@"********** %@", [(UIViewController *)_delegate navigationController].viewControllers);
        if([self.navigationController.viewControllers containsObject:self]){
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [_delegate globalSymbolSearchViewControllerDidCancelSearch:self];
        }
    }
}

-(IBAction)doneAction:(id)sender
{
    //select symbol from the search list...
    NSString *expiryDate = @"null";
    NSString *optionType = @"null";
    NSString *strikePrice = @"0";
    BOOL sendRequest = YES;
    TTAlertView *alertView = [TTAlertView sharedAlert];
    if(_isExpiry == YES)
        expiryDate = self.currentSelectedCell.expiryDateButton.titleLabel.text;
    
    if(_isExpiry == YES && ([expiryDate isEqualToString:@"null"] || [expiryDate isEqualToString:@"Expiry Date"])){
        //dont allow the user to proceed without selecting the expiry date...
        sendRequest = NO;
        
        [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Expiry_Date_Selection", @"Localizable",@"Please select Expiry Date for the symbol")];
    }
    if(_isOptionSeries){
        optionType = self.currentSelectedCell.optionButton.titleLabel.text;
        strikePrice = self.currentSelectedCell.strikePriceButton.titleLabel.text;
        
        if(([optionType isEqualToString:@"null"] || [optionType isEqualToString:@"Option Type"] || [strikePrice isEqualToString:@"0"] || [strikePrice isEqualToString:@"Strike Price"]) &&sendRequest){
            sendRequest = NO;
            [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Missing_Symbol_Details", @"Localizable",@"Please select all the details for the symbol")];
        }
    }
    
    if(sendRequest){
        
        if(_searchType == eDefault){
            NSString *relativePathString = [NSString stringWithFormat:@"instruments/%@/%@/%@/%@/%@/%@/%@",self.currentSelectedSymbolSearch.symbolData.symbolName,_currentSelectedExchange,[SBITradingUtility getInstrumentTypeURLKey:_currentSelectedInstrument],self.currentSelectedSymbolSearch.series,optionType,expiryDate,strikePrice];
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
                        [_delegate globalSymbolSearchViewController:self didSelectSymbol:symbolData];
                        NSLog(@"%@",self.navigationController.viewControllers);
                        //                    if([self.navigationController.viewControllers containsObject:self]){
                        //                        [self.navigationController popViewControllerAnimated:YES];
                        //                    }
                        //                    else{
                        //                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                        //                    }
                        
                    });
                }
            }];
        }
        else{
            self.currentSelectedSymbolSearch.symbolData.instrumentType = [SBITradingUtility getInstrumentTypeURLKey:_currentSelectedInstrument];
            [_delegate globalSymbolSearchViewController:self didSelectSymbol:self.currentSelectedSymbolSearch.symbolData];
        }
        
        
    }
}

-(void)setTheInstrumentMode{
    switch (_instrumentMode) {
        case iDefaultMode:
        {
            _isOptionSeries = YES;
            _isExpiry = YES;
        }
            break;
        case iEquityMode:
        {
            _isOptionSeries = NO;
            _isExpiry = NO;
        }
            break;
        case iFutureMode:
        {
            _isExpiry = YES;
            _isOptionSeries = NO;
        }
            break;
        case iOptionMode:
        {
            if(_searchType == eDefault){
                _isOptionSeries = YES;
                _isExpiry = YES;
            }
            else{
                _isOptionSeries = NO;
                _isExpiry = NO;
            }
            
        }
            break;
            
        default:
            break;
    }
}

#pragma UISearchBar Delegate Method

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"Searhc bar is %@",searchBar);
    //    UITextField *textField = [[searchBar subviews] objectAtIndex:1];
    //    [textField setFont:REGULAR_FONT_SIZE(15.0)];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:REGULAR_FONT_SIZE(15.0)];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [self searchSymbols];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    [self searchSymbols];
    return YES;
}

-(void)searchSymbols{
    [self dismissPopOverAndKeyboard];
    self.previousSelectedCell = nil;
    self.currentSelectedCell = nil;
    //get the list of symbols after the search...
    _symbolResultArray = [[NSMutableArray alloc] init];
    if([_searchBar.text length] > 0){
        NSString *relativePathString = [NSString stringWithFormat:@"instruments/%@/%@/%@",_searchBar.text,_currentSelectedExchange,[SBITradingUtility getInstrumentTypeURLKey:_currentSelectedInstrument]];
        NSLog(@"Request URL is %@",relativePathString);
        SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
        [networkManager makeGETRequestWithRelativePath:relativePathString responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
            if (data.length > 0) {
                NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
                NSLog(@"%@ and status code is %@",jsonString,response);
                NSError *jsonParsingError = nil;
                NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
                if(responseArray && [responseArray isKindOfClass:[NSArray class]]){
                    for(id symbolData in responseArray){
                        TTSymbolSearch *symbol = [[TTSymbolSearch alloc] initWithDictionary:symbolData];
                        TTCellData *cellData = [[TTCellData alloc] init];
                        cellData.symbolData = symbol;
                        [_symbolResultArray addObject:cellData];
                    }
                }
                
                if([_symbolResultArray count] == 0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        TTAlertView *alertView = [TTAlertView sharedAlert];
                        [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"No_Result", @"Localizable",@"No result found")];
                    });
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_symbolsListView reloadData];
                });
            }
        }];
    }
    else{
        TTAlertView *alertView = [TTAlertView sharedAlert];
        [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Missing_Keyword", @"Localizable",@"Please enter a keyword to perform search")];
    }
}


#pragma TableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _symbolsListView){
        if(_isExpiry == YES)
            return 64;
    }
    else
        return 44;
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _symbolsListView)
    {
        return [_symbolResultArray count];
    }
    else if(tableView == self.popOverOptionTableView)
    {
        return [_optionsArray count];
        
    }
    else{
        return [self.expiryDateArray count];
        
        
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = nil;
    
    if(tableView == _symbolsListView)
    {
        CellIdentifier = @"SymbolSCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTSymbolSearchTableCell" owner:self options:nil];
            
            for(id oneObject in nib) {
                
                if([oneObject isKindOfClass:[TTSymbolSearchTableCell class]]) {
                    
                    cell = (TTSymbolSearchTableCell *)oneObject;
                    [ (TTSymbolSearchTableCell *)cell setSelectSymbolDelegate: self];
                    
                }
            }
            TTSymbolSearchTableCell *customCell = (TTSymbolSearchTableCell *)cell;
            // [customCell.selectSymbolButton setBackgroundImage:[UIImage imageNamed:@"redio_button_select.png"] forState:UIControlStateSelected];
            customCell.symbolCellData = [_symbolResultArray objectAtIndex:indexPath.row];
            if(_searchType == eOptionChainSearch){
                _isExpiry = NO;
                customCell.expiryDateButton.hidden = YES;
                customCell.optionButton.hidden = YES;
                customCell.strikePriceButton.hidden = YES;
            }
            
            else{
                if(_isExpiry && _isOptionSeries){
                    customCell.optionButton.hidden = NO;
                    customCell.strikePriceButton.hidden = NO;
                }
                else{
                    customCell.optionButton.hidden = YES;
                    customCell.strikePriceButton.hidden = YES;
                }
            }
            
            [customCell paintUI];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.textLabel.text = [self.optionsArray objectAtIndex:indexPath.row];
            
        }
        cell.textLabel.font = [UIFont systemFontOfSize:11.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(tableView == self.popOverOptionTableView){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [self.optionsArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:11.0];
        
    }
    
    //changes added with the new model ..... recheck..
    
    else if(tableView == self.popOverTableView){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [self.expiryDateArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:11.0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(InstrumentType)returnIntrumentTypeForIndex:(int)index{
    if(index == 0)
        return OPTION_STOCK;
    else if(index == 1)
        return OPTION_INDEX;
    else
        return OPTION_CURRENCY;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:96.0/255.0 blue:254.0/255.0 alpha:1];
    
    if(tableView == _symbolsListView)
    {
        
    }
    else if(tableView == self.popOverOptionTableView)
    {
        if(_isInstrumentSelected){
            
            if(_searchType == eDefault)
                _currentSelectedInstrument = (InstrumentType)indexPath.row;
            else
                _currentSelectedInstrument = [self returnIntrumentTypeForIndex:indexPath.row];
            
            if(_currentSelectedInstrument == OPTION_STOCK || _currentSelectedInstrument == OPTION_INDEX || _currentSelectedInstrument == OPTION_CURRENCY){
                _instrumentMode = iOptionMode;
            }
            else if(_currentSelectedInstrument == EQUITY){
                _instrumentMode = iEquityMode;
            }
            else{
                _instrumentMode = iFutureMode;
            }
            [self setTheInstrumentMode];
            [_btnInstrumentType setTitle:[self.optionsArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        }
        else{
            _currentSelectedExchange = [self.optionsArray objectAtIndex:indexPath.row];
            [_btnExchangeType setTitle:[self.optionsArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        }
        //Search the symbol...
        if([_searchBar.text length] > 0){
            [self searchSymbols];
        }
    }
    else{
        
        TTCellData *currentCellData = self.currentSelectedCell.symbolCellData;
        
        if(self.isExpiryDateSelected){
            currentCellData.expiryDate = [self.expiryDateArray objectAtIndex:indexPath.row];
            [self.currentSelectedCell.expiryDateButton setTitle:currentCellData.expiryDate forState:UIControlStateNormal];
            
        }
        else if(self.isOptionTypeSelected){
            
            currentCellData.optionType = [self.expiryDateArray objectAtIndex:indexPath.row];
            [self.currentSelectedCell.optionButton setTitle:currentCellData.optionType forState:UIControlStateNormal];
        }
        else{
            
            currentCellData.strikePrice = [self.expiryDateArray objectAtIndex:indexPath.row];
            [self.currentSelectedCell.strikePriceButton setTitle:currentCellData.strikePrice forState:UIControlStateNormal];
        }
        
        //        [self.symbolsListView reloadData];
        
    }
    if([self.selectPopoverController isPopoverVisible]){
        [self.selectPopoverController dismissPopoverAnimated:YES];
        self.selectPopoverController = nil;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (editingStyle == UITableViewCellEditingStyleDelete && tableView.tag == 1) {
    //        int index = indexPath.row;
    //        //delete this object from the array...
    //        TTDiffusionData *toDeleteSymbol = [self.symbolsArray objectAtIndex:index];
    //
    //        if([self.newlyAddedsymbolArray containsObject:toDeleteSymbol]){
    //            //this symbol is not added to the main watchlist object yet...
    //            //Remove it only from the local array...
    //
    //            [self.newlyAddedsymbolArray removeObject:toDeleteSymbol];
    //            [self.symbolsArray removeObject:toDeleteSymbol];
    //
    //        }
    //        else{
    //            [self deleteSymbolFromWatchlist:toDeleteSymbol.symbolData.jsonRawDictionary];
    //            [self.symbolsArray removeObjectAtIndex:index];
    //        }
    //
    //        [self.symbolTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    //    }
}


- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

#pragma delegate method

-(void)selectSearchSymbol:(TTSymbolSearch *)symbolSearchData ForCell:(TTSymbolSearchTableCell *)cell{
    
    TTSymbolSearchTableCell *currentCellCopy = self.currentSelectedCell;
    
    //deselect the previously selected symbol...
    BOOL initialLoadFlag = NO;
    if(self.previousSelectedCell == nil && self.currentSelectedCell == nil){
        //first selection...
        initialLoadFlag = YES;
        self.previousSelectedCell = cell;
    }
    else{
        self.previousSelectedCell = currentCellCopy;
    }
    self.currentSelectedCell = cell;
    
    NSIndexPath *currentSelectedCellIndexPath = [self.symbolsListView indexPathForCell:self.currentSelectedCell];
    NSIndexPath *previousSelectedCellIndexPath = [self.symbolsListView indexPathForCell:self.previousSelectedCell];
    
    if(previousSelectedCellIndexPath == nil){
        previousSelectedCellIndexPath = self.previousIndexPath;
        NSLog(@"index.row is before ...... %d",self.previousIndexPath.row);
        self.previousSelectedCell = (TTSymbolSearchTableCell *)[self.symbolsListView cellForRowAtIndexPath:previousSelectedCellIndexPath];
    }
    else{
        self.previousIndexPath = currentSelectedCellIndexPath;
        NSLog(@"index.row is %d adn %d",self.previousIndexPath.row,previousSelectedCellIndexPath.row);
    }
    
    
    TTCellData *currentCellData = [self.symbolResultArray objectAtIndex:currentSelectedCellIndexPath.row];
    TTCellData *previousCellData = [self.symbolResultArray objectAtIndex:previousSelectedCellIndexPath.row];
    
    NSLog(@"Current %@ and previous %@ with index %d",currentCellData.symbolData.symbolData.symbolName,previousCellData.symbolData.symbolData.symbolName,previousSelectedCellIndexPath.row);
    
    if(!initialLoadFlag){
        if(currentCellData.symbolData.symbolData.subscriptionKey == previousCellData.symbolData.symbolData.subscriptionKey){
            
            [self.previousSelectedCell.selectSymbolButton setBackgroundImage:[UIImage imageNamed:@"redio_button_unselect.png"] forState:UIControlStateNormal];
            
            self.currentSelectedCell = nil;
            self.previousSelectedCell = nil;
            self.currentSelectedSymbolSearch = nil;
            
            currentCellData.isSelected = NO;
            previousCellData.isSelected = NO;
        }
        else{
            //deselect the previously selected symbol...
            [self.previousSelectedCell.selectSymbolButton setBackgroundImage:[UIImage imageNamed:@"redio_button_unselect.png"] forState:UIControlStateNormal];
            self.currentSelectedSymbolSearch = symbolSearchData;
            
            currentCellData.isSelected = YES;
            previousCellData.isSelected = NO;
        }
    }
    else{
        self.currentSelectedSymbolSearch = symbolSearchData;
        currentCellData.isSelected = YES;
        //        previousCellData.isSelected = YES
    }
    //    [self.symbolsListView reloadData];
    NSLog(@"current symbol is %@",self.currentSelectedSymbolSearch);
}


-(void)displayExpiryDatePopOver:(TTSymbolSearchTableCell*)cell{
    [self dismissPopOverAndKeyboard];
    //get the expiry date...
    self.isExpiryDateSelected = YES;
    self.isOptionTypeSelected = NO;
    self.isStrikePriceSelected = NO;
    if(self.currentSelectedSymbolSearch != NULL){
        [self showPopOverFor:@"expiry"];
        
        UIViewController* controller = [[UIViewController alloc] init];
        controller.view = self.popoverView;
        
        self.selectPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.selectPopoverController setPopoverContentSize:CGSizeMake(self.popoverView.frame.size.width, self.popoverView.frame.size.height)];
        NSLog(@"%@ and %@",NSStringFromCGRect([cell convertRect:cell.expiryDateButton.frame toView:self.symbolsListView]),NSStringFromCGRect([cell.expiryDateButton bounds]));
        [self.selectPopoverController presentPopoverFromRect:[cell convertRect:cell.expiryDateButton.frame toView:self.symbolsListView] inView:self.symbolsListView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    
}

-(void)displayOptionTypePopOver:(TTSymbolSearchTableCell*)cell{
    [self dismissPopOverAndKeyboard];
    //get the option type...
    self.isExpiryDateSelected = NO;
    self.isOptionTypeSelected = YES;
    self.isStrikePriceSelected = NO;
    if(self.currentSelectedSymbolSearch != NULL){
        [self showPopOverFor:@"optionType"];
        
        UIViewController* controller = [[UIViewController alloc] init];
        controller.view = self.popoverView;
        
        self.selectPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.selectPopoverController setPopoverContentSize:CGSizeMake(self.popoverView.frame.size.width, self.popoverView.frame.size.height)];
        [self.selectPopoverController presentPopoverFromRect:[cell convertRect:cell.optionButton.frame toView:self.symbolsListView] inView:self.symbolsListView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    
}

-(void)displayStrikePricePopOver:(TTSymbolSearchTableCell*)cell{
    
    [self dismissPopOverAndKeyboard];
    //get the option type...
    self.isExpiryDateSelected = NO;
    self.isOptionTypeSelected = NO;
    self.isStrikePriceSelected = YES;
    if(self.currentSelectedSymbolSearch != NULL){
        [self showPopOverForStrikePrice];
        
        UIViewController* controller = [[UIViewController alloc] init];
        controller.view = self.popoverView;
        
        self.selectPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.selectPopoverController setPopoverContentSize:CGSizeMake(self.popoverView.frame.size.width, self.popoverView.frame.size.height)];
        [self.selectPopoverController presentPopoverFromRect:[cell convertRect:cell.strikePriceButton.frame toView:self.symbolsListView] inView:self.symbolsListView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    
}


-(void)showPopOverForStrikePrice{
    NSString *relativePathString = [NSString stringWithFormat:@"instruments/%@/%@/%@/%@",self.currentSelectedSymbolSearch.symbolData.symbolName,_currentSelectedExchange,self.currentSelectedCell.optionButton.titleLabel.text,self.currentSelectedCell.expiryDateButton.titleLabel.text];
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popOverTableView reloadData];
            });
        }
    }];
}

-(void)showPopOverFor:(NSString *)type{
    NSString *relativePathString = [NSString stringWithFormat:@"instruments/%@/%@/%@/%@",type,self.currentSelectedSymbolSearch.symbolData.symbolName,_currentSelectedExchange,[SBITradingUtility getInstrumentTypeURLKey:_currentSelectedInstrument]];
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popOverTableView reloadData];
            });
        }
    }];
}

-(void)dismissPopOverAndKeyboard{
    
    if([self.selectPopoverController isPopoverVisible]){
        [self.selectPopoverController dismissPopoverAnimated:YES];
    }
    self.selectPopoverController = nil;
    [_searchBar resignFirstResponder];
}

@end
