//
//  TTWatchlistEntryViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 12/11/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTWatchlistEntryViewController.h"
#import "SBITradingNetworkManager.h"
#import "TTWatchlist.h"
#import "SBITradingUtility.h"
#import "TTDiffusionData.h"
#import "TTDismissingView.h"
#import <QuartzCore/QuartzCore.h>
#import "TTAlertView.h"
#import "TTUrl.h"

@interface TTWatchlistEntryViewController ()
@property(nonatomic,weak)IBOutlet UITableView *watchListTableView;
@property(nonatomic,weak)IBOutlet UIButton *addNewWatchlistButton;
@property(nonatomic,strong)NSMutableArray *watchListArray;
@property(nonatomic,strong)TTCreateWatchListViewController *editWatchListVieController;
@property(nonatomic,strong)NSIndexPath *indexPathToBeDeleted;
@property(nonatomic,weak)IBOutlet UIView *headerView;


-(IBAction)addNewWatchlist:(id)sender;
@end

@implementation TTWatchlistEntryViewController

@synthesize loadWatchlistDelegate;

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
    self.navigationController.view.bounds = CGRectMake(0, 0, 428, 506);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    //set the heading and button title ...
    [_cancelButton setTitle:NSLocalizedStringFromTable(@"Cancel_Button_Title", @"Localizable", @"Cancel") forState:UIControlStateNormal];
    _watchlistEntryTitle.text = NSLocalizedStringFromTable(@"Watchlist_Entry", @"Localizable", @"Watchlist");
    _watchlistEntryTitle.font = SEMI_BOLD_FONT_SIZE(22.0);
    if(self.isCalledFromOtherScreen)
        self.addNewWatchlistButton.hidden = YES;
    else
        self.addNewWatchlistButton.hidden = NO;
    
    _cancelButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);
    
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"Default"];
    
    if(self.shouldShowBackButton){
        [self.cancelButton setTitle:self.previousScreenTitle forState:UIControlStateNormal];
        [self.cancelButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [self.cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0,-5,0,0)];
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
//    UIWindow *window = [SBITradingUtility returnWindowObject];
    
//    TTDismissingView *dismissView = [[TTDismissingView alloc] initWithFrame:window.frame target:self selector:@selector(dismissView:)];
//    [dismissView addToWindow:window];
    self.navigationController.view.superview.backgroundColor = [UIColor clearColor];
    self.watchListArray = [[NSMutableArray alloc] init];
    
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    [networkManager makeGETRequestWithRelativePath:[TTUrl watchListURL] responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        NSError *jsonParsingError = nil;
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        if(responseArray){
            for(id watchlist in responseArray){
                TTWatchlist *watchListObj = [[TTWatchlist alloc] init];
                watchListObj.watchlistID = [[watchlist valueForKey:@"id"] intValue];
                watchListObj.watchListName = [watchlist valueForKey:@"name"];
                watchListObj.isDefaultWatchlist = ([[watchlist valueForKey:@"isDefaultMarketWatch"] intValue] == 1)?@"true":@"false";
                watchListObj.isSystemWatchlist = ([[watchlist valueForKey:@"isSystemMarketWatch"] intValue] == 1)?@"true":@"false";
                
                [self.watchListArray addObject:watchListObj];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.watchListTableView reloadData];
        });
        
    }];
}

//-(void)dismissView:(id)sender{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.watchListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    TTWatchListTableViewCell *cell = nil;
    
    if (cell == nil) {
        cell = (TTWatchListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTWatchListTableViewCell" owner:self options:nil];
        
        for(id oneObject in nib) {
            
            if([oneObject isKindOfClass:[TTWatchListTableViewCell class]]) {
                
                cell = (TTWatchListTableViewCell *)oneObject;
                cell.selectWatchlistDelegate = self;
            }
            
        }
        
    }
    
    TTWatchlist *currentWatchList = [self.watchListArray objectAtIndex:indexPath.row];
    cell.watchListData = currentWatchList;
    cell.watchListNameLabel.text = currentWatchList.watchListName;
    if([currentWatchList.isSystemWatchlist isEqualToString:@"false"])
        cell.watchlistInfoButton.hidden = NO;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //show the corresponding symbol set...
    
    TTWatchListTableViewCell *cell = (TTWatchListTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.watchListNameLabel.textColor = [UIColor blueColor];
    
    TTWatchlist *selectedWatchlist = [self.watchListArray objectAtIndex:indexPath.row];
    
    NSString *relativePathString = [NSString stringWithFormat:@"/%d/%@",selectedWatchlist.watchlistID,selectedWatchlist.isSystemWatchlist];
    
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    [networkManager makeGETRequestWithRelativePath:[[TTUrl watchListURL] stringByAppendingString:relativePathString] responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
        NSLog(@"%@ and status code is %@",jsonString,response);
        NSError *jsonParsingError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(self.isCalledFromOtherScreen){
                [self addSymbolWithData:responseDictionary toWatchlist:selectedWatchlist];
                
            }
            else{
                SBITradingUtility *utilityObj = [SBITradingUtility sharedUtility];
                utilityObj.currentSelectedWatchlist = selectedWatchlist;
                NSLog(@"loadWatchlistDelegate is %@",loadWatchlistDelegate);
                [loadWatchlistDelegate loadSymbolsForWatchList:[responseDictionary valueForKey:@"instumentVOList"] andWatchlistObject:selectedWatchlist];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        });
        
    }];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
}

-(void)addSymbolWithData:(NSDictionary *)inResponseDictionary toWatchlist:(TTWatchlist *)inWatchlist{
    
    // get the list of the symbols and perform a comparision ...
    NSArray *rawDataArray = [inResponseDictionary valueForKey:@"instumentVOList"];
    NSMutableArray *symbolsArray = [[NSMutableArray alloc] init];
    for(NSDictionary *symbol in rawDataArray){
        if(symbol != [NSNull null]){
            TTSymbolData *symbolData = [[TTSymbolData alloc] initWithDictionary:symbol];
            
            symbolData.jsonRawDictionary = symbol;
            
            TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
            diffusionData.symbolData = symbolData;
            [symbolsArray addObject:diffusionData];
        }
    }
    
    TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
    diffusionData.symbolData = self.currentSymbol;
    diffusionData.symbolData.jsonRawDictionary = self.currentSymbol.jsonRawDictionary;
    NSLog(@"Current symbol is %@",self.currentSymbol.jsonRawDictionary);
    //check if the symbol already exists in the watchlist...
    
    BOOL doesSymbolExist = NO;
    
    NSLog(@"Symbol array is %@",symbolsArray);
    
    for(TTDiffusionData *data in symbolsArray){
        NSLog(@"data is %@ with name %@",data.symbolData.subscriptionKey,data.symbolData.symbolName);
        NSLog(@"diffusion data is %@ with name %@",diffusionData.symbolData.subscriptionKey,diffusionData.symbolData.symbolName);
        if([data.symbolData.subscriptionKey isEqual:diffusionData.symbolData.subscriptionKey] || [data.symbolData.tradeSymbolName isEqualToString:diffusionData.symbolData.tradeSymbolName]){
            doesSymbolExist = YES;
            break;
        }
    }
    
    if(doesSymbolExist){
        TTAlertView *alertView = [TTAlertView sharedAlert];
        [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Symbol_Already_Present", @"Localizable",@"Symbol already exists in the watchlist")];
    }
    else{
        //add the selected symbol instrument to the list...
        //        [symbolsArray addObject:diffusionData];
        
        //send a post request to the server with the new addition of the symbol ...
        NSString *relativePath = [NSString stringWithFormat:@"watchlists/%d/symbols",inWatchlist.watchlistID];
        
        //make the POST body...
        
        //        for(TTDiffusionData *data in symbolsArray){
        SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
        NSLog(@"Post body is %@",diffusionData.symbolData.jsonRawDictionary);
        
        NSArray *postBodyArray = [NSArray arrayWithObject:diffusionData.symbolData.jsonRawDictionary];
        
        [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:postBodyArray responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
            
            NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
            NSLog(@"Response is %d",recievedResponse.statusCode);
            if(recievedResponse.statusCode == 200){
                dispatch_async(dispatch_get_main_queue(), ^{
                    TTAlertView *alertView = [TTAlertView sharedAlert];
                    [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Symbol_Added_Success", @"Localizable",@"Symbol successfully added to the selected watchlist")];
                    [self.navigationController popViewControllerAnimated:YES];
                    //check if the dashboard has the same watchlist loaded already
                    SBITradingUtility *utilityObj = [SBITradingUtility sharedUtility];
                    if(utilityObj.currentSelectedWatchlist.watchlistID == inWatchlist.watchlistID){
                        //refresh the presented watchlist ...
                        [loadWatchlistDelegate refreshWatchlist:inWatchlist];
                        NSLog(@"response dict is %@",postBodyArray);
                    }
//                    self.navigationController.view.bounds = self.previousScreenFrame;
                    
                    
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    TTAlertView *alertView = [TTAlertView sharedAlert];
                    [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Request_Failure", @"Localizable",@"Unable to proceed with the request")];
                    //                        [self.navigationController popViewControllerAnimated:YES];
                    
                });
            }
        }];
        //        }
        
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TTWatchlist *currentWatchList = [self.watchListArray objectAtIndex:indexPath.row];
    if ([currentWatchList.isSystemWatchlist isEqualToString:@"false"])
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        self.indexPathToBeDeleted = indexPath;
        
        UIAlertView *confirmDeleteAlertView = [[UIAlertView alloc] initWithTitle:@"Watchlist Deletion" message:@"Do you want to delete the selected watchlist" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        confirmDeleteAlertView.tag = 1000;
        [confirmDeleteAlertView show];
        
    }
}


-(void)deleteWatchlist{
    int index = self.indexPathToBeDeleted.row;
    //delete this object from the array...
    TTWatchlist *toDeleteWatchlist = [self.watchListArray objectAtIndex:index];
    
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    NSString *relativePath = [NSString stringWithFormat:@"%@/%d",[TTUrl watchListURL],toDeleteWatchlist.watchlistID];
    [networkManager makeDELETERequestWithRelativePath:relativePath withPostBody:nil responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
        if(recievedResponse.statusCode == 200){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.watchListArray removeObjectAtIndex:index];
                [self.watchListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathToBeDeleted] withRowAnimation:UITableViewRowAnimationRight];
                //check if the watchlist was loaded in the dashboard...
                
//                if(loadWatchlistDelegate && [loadWatchlistDelegate respondsToSelector:@selector(showWatchlistWithID:tobe)])
//                {
                    //load the first watchlist ...
                SBITradingUtility *utilityObj = [SBITradingUtility sharedUtility];
                if(utilityObj.currentSelectedWatchlist.watchlistID == toDeleteWatchlist.watchlistID){
                    TTWatchlist *toBeLoadedWatchlist;
                    if(index >= 0 && [self.watchListArray count] >= 1)
                        toBeLoadedWatchlist = [self.watchListArray objectAtIndex:0];
                    else
                        toBeLoadedWatchlist = [self.watchListArray objectAtIndex:1];
                    [loadWatchlistDelegate showWatchlist:toBeLoadedWatchlist];
                }

            });
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                TTAlertView *alertView = [TTAlertView sharedAlert];
                [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Delete_Failure", @"Localizable", @"Unable to delete the selected watchlist")];
            });
        }
        
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1000){
        if(buttonIndex == 0){
            //delete the watchlist...
            [self deleteWatchlist];
        }
        else{
            NSLog(@"Do nothing !!");
        }
    }
}

#pragma IBAction

#pragma mark ---
#pragma mark AddNewWatchlistView delegate methods
-(void) searchEnded {
    [self.view endEditing:YES];
}

-(IBAction)cancelAction:(id)sender
{
    if(!self.shouldShowBackButton){
        //isEnlargedView = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if([self.previousScreenTitle isEqualToString:@"OC"]){
        self.navigationController.view.bounds = self.previousScreenFrame;
        [self.navigationController popViewControllerAnimated:YES];
//        self.navigationController.view.frame = self.previousScreenFrame;
//        self.navigationController.view.center = CGPointMake(512, 350);
//        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
//    if(self.isCalledFromOtherScreen)
//        [self.navigationController dismissViewControllerAnimated:YES completion:^{
//            [self.navigationController popToRootViewControllerAnimated:NO];
//        }];
//    else{
//        [self.navigationController dismissViewControllerAnimated:YES completion:^{
//            NSLog(@"Dismissed Complete");
//            NSLog(@"nav controller is %@",self.navigationController);
//        }];
//    }

}


-(IBAction)addNewWatchlist:(id)sender{
    //push the add new watchlist screen...
    //    [self.loadWatchlistDelegate dismissThePopOver];
    
//    if(!_editWatchListVieController)
        _editWatchListVieController = [[TTCreateWatchListViewController alloc] initWithNibName:@"TTCreateWatchListViewController" bundle:nil];
    
    _editWatchListVieController.recievedWatchlistObj = nil;
    _editWatchListVieController.refreshWatchListDelegate = self.parentController;
    _editWatchListVieController.watchListMode = eCreateMode;
    _editWatchListVieController.shoulUpdateSymbols = NO;
    _editWatchListVieController.recievedWatchlistObj = nil;
    if(self.navigationController != NULL){
        _editWatchListVieController.shouldShowBackButton = YES;
        [self.navigationController pushViewController:_editWatchListVieController animated:YES];
    }
    else
    {
        _editWatchListVieController.shouldShowBackButton = NO;
        _editWatchListVieController.navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:_editWatchListVieController.navigationController animated:YES completion:nil];
    }
    _editWatchListVieController.title =  NSLocalizedStringFromTable(@"Create_Watchlist", @"Localizable", @"Create Watchlist");
    
}

#pragma delegates

-(void)editWatchlist:(TTWatchlist *)watchlist{
    
    
    if(!self.isCalledFromOtherScreen){
        if([watchlist.isSystemWatchlist isEqualToString:@"false"]){
            //        [self.loadWatchlistDelegate dismissThePopOver];
            
            if(!_editWatchListVieController)
                _editWatchListVieController = [[TTCreateWatchListViewController alloc] initWithNibName:@"TTCreateWatchListViewController" bundle:nil];
            
            _editWatchListVieController.recievedWatchlistObj = nil;
            _editWatchListVieController.refreshWatchListDelegate = self.parentController;
            _editWatchListVieController.watchListMode = eWatchlistEditableMode;
            _editWatchListVieController.shoulUpdateSymbols = YES;
            _editWatchListVieController.recievedWatchlistObj = watchlist;
            //
            if(self.navigationController != NULL){
                _editWatchListVieController.shouldShowBackButton = YES;
                [self.navigationController pushViewController:_editWatchListVieController animated:YES];
            }
            else
            {
                _editWatchListVieController.shouldShowBackButton = NO;
                _editWatchListVieController.navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
                [self presentViewController:_editWatchListVieController.navigationController animated:YES completion:nil];
            }
            
            _editWatchListVieController.title =  NSLocalizedStringFromTable(@"Add_Symbols", @"Localizable", @"Add Symbols");
        }
        else{
            TTAlertView *alertView = [TTAlertView sharedAlert];
            [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"SystemWatchlist_Edit", @"Localizable",@"System Watchlist cant be edited")];
        }
    }
    
}


@end
