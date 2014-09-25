//
//  TTMarqueeViewController.m
//  TavantTrade
//
//  Created by Gautham S Shetty on 23/12/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTMarqueeViewController.h"
#import "SBITradingNetworkManager.h"
#import "TTDiffusionHandler.h"
#import "TTSymbolData.h"
#import "TTDiffusionData.h"
#import "SBITradingUtility.h"
#import "MKTickerView.h"
#import "TTUrl.h"

@interface TTMarqueeViewController ()
{
    
}
@property(nonatomic,strong)TTDiffusionHandler *diffusion;

- (void) initialize;
@end


@implementation TTMarqueeViewController
@synthesize  marqueeDatasourceList = _marqueeDatasourceList;
@synthesize marqueeTableView = _marqueeTableView;
@synthesize btnExchangeType = _btnExchangeType;
@synthesize diffusion;
@synthesize marqueeDataDict = _marqueeDataDict;
@synthesize tickerView = _tickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initialize];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initialize];
    }
    return self;
}

- (void) initialize
{
    _marqueeDataDict = [[ NSMutableDictionary alloc] init];
    self.marqueeDatasourceList = [[NSMutableArray alloc] init];
    self.selectedExchangeType = eNSE;
//    [self.exchangeSelectionDelegate setCurrentSelectedExchanegType:self.selectedExchangeType];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateExchangeType:) name:@"UpdateExchangeType" object:[NSNumber numberWithInt:self.selectedExchangeType]];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateExchangeType" object:[NSNumber numberWithInt:self.selectedExchangeType]];
}


//-(void)setSelectedExchangeType:(EExchangeType)selectedExchangeType
//{
//    selectedExchangeType = selectedExchangeType;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self requestMarqueeDataForType:eNSE];
    [self updateExchangeTypeButton];
    
    diffusion = [TTDiffusionHandler sharedDiffusionManager];
    [diffusion initDiffusion];
    [diffusion connectWithViewControllerContext:self];
    [self requestMarqueeDataForType:eNSE];
    [self requestMarqueeDataForType:eBSE];
    _btnExchangeType.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:20.0];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateExchangeType" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateExchangeType" object:nil];
    // Dispose of any resources that can be recreated.
}
-(void)updateExchangeTypeButton
{
    NSString *exchangeTypeTitle = [SBITradingUtility getTitleForEchangeType:self.selectedExchangeType];
//    [self.exchangeSelectionDelegate setCurrentSelectedExchanegType:self.selectedExchangeType];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateExchangeType" object:[NSNumber numberWithInt:self.selectedExchangeType]];
    [_btnExchangeType setTitle:exchangeTypeTitle forState:UIControlStateNormal];
    [_tickerView reloadData];
}


-(IBAction)switchExchangeType:(id)sender
{
    if(_selectedExchangeType == eNSE)
        _selectedExchangeType = eBSE;
    else
        _selectedExchangeType = eNSE;
    [self updateExchangeTypeButton];
}


#pragma MKTickerView Delegate Methods
- (UIColor*) backgroundColorForTickerView:(MKTickerView *)vertMenu
{
    return [UIColor colorWithRed:50.0/255.0 green:53.0/255.0 blue:57.0/255.0 alpha:1.0];
}

- (int) numberOfItemsForTickerView:(MKTickerView *)tabView
{
    NSMutableArray *symbolListArray = (_selectedExchangeType == eNSE) ? [_marqueeDataDict objectForKey:[NSString stringWithFormat:@"%d",eNSE]] : [_marqueeDataDict objectForKey:[NSString stringWithFormat:@"%d",eBSE]];
    
    NSLog(@"  Exchange Type : %d    Symbol Count : %d", _selectedExchangeType, [symbolListArray count]);
    return [symbolListArray count];
}

- (id) tickerView:(MKTickerView *)tickerView dataForItemAtIndex:(NSUInteger) index
{
    NSMutableArray *symbolListArray = (_selectedExchangeType == eNSE) ? [_marqueeDataDict objectForKey:[NSString stringWithFormat:@"%d",eNSE]] : [_marqueeDataDict objectForKey:[NSString stringWithFormat:@"%d",eBSE]];
    
    TTDiffusionData *diffusionObj = [symbolListArray objectAtIndex:index];
    return diffusionObj;
}
-(void)requestMarqueeDataForType:(EExchangeType)inType
{
    //select symbol from the search list...
    NSString *relativePathString = @"";
    
    
    switch (inType) {
        case eNSE:
        {
            relativePathString = [TTUrl tickerNSEURL];
            
        }
            break;
        case eBSE:
        {
            relativePathString = [TTUrl tickerBSEURL];
        }
            break;
        default:
            break;
    }
    NSLog(@"Request URL is %@",relativePathString);
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    [networkManager makeGETRequestWithRelativePath:relativePathString responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        if([data length] > 0){
//            NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
//            NSLog(@"%@ and status code is %@",jsonString,response);
            
            NSError *jsonParsingError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
//            NSLog(@"Symbol Search Instrument is %@",responseDictionary);
            
            NSString *idvalue = [responseDictionary objectForKey:@"id"];
            
            NSString *relativePathString = [NSString stringWithFormat:@"/instruments/%@", idvalue];
            
            [networkManager makeGETRequestWithRelativePath:relativePathString responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
                
//                NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
//                NSLog(@"%@ and status code is %@",jsonString,response);
                
                NSError *jsonParsingError = nil;
                NSMutableArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
//                NSLog(@"Marquee Data is %@",responseArray);
                
                NSMutableArray *marqueeArray = [NSMutableArray array];
                for(NSDictionary *symbol in responseArray){
                    if(symbol){
                        TTSymbolData *symbolData = [[TTSymbolData alloc] initWithDictionary:symbol];
                        TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
                        symbolData.jsonRawDictionary = symbol;
                        diffusionData.symbolData = symbolData;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [diffusion subscribe:symbolData.subscriptionKey withContext:self];
                            
                        });
                        [marqueeArray addObject:diffusionData];
                    }
                }
                
                [_marqueeDataDict setObject:marqueeArray forKey:[NSString stringWithFormat:@"%d",inType ]];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(inType == _selectedExchangeType)
                    [_tickerView performSelector:@selector(reloadData) withObject:nil afterDelay:3];
            });

        }
    }];
}



#pragma Diffusion Delegates

-(void)onConnectionWithStatus:(BOOL)isConnected{
    
    //get the watchlist...
    
    if(isConnected){
        [self requestMarqueeDataForType:_selectedExchangeType];
    }
}

-(void)onDelta:(DFTopicMessage *)message{
    
    //find the row to be updated...
    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
    NSMutableArray *symbolListArray = (_selectedExchangeType == eNSE) ? [_marqueeDataDict objectForKey:[NSString stringWithFormat:@"%d",eNSE]] : [_marqueeDataDict objectForKey:[NSString stringWithFormat:@"%d",eBSE]];
    
    
    for(id symbols in symbolListArray){
        TTDiffusionData *diffusionData = (TTDiffusionData *)symbols;
        if([diffusionData.symbolData.subscriptionKey isEqualToString:message.topic]){
            //access the index path...
            diffusionData = [diffusionData updateDiffusionDataWith:parsedArray];
            
            //To update the single Item from a Ticker View and update it immediately.
            NSUInteger index = [symbolListArray indexOfObject:symbols];
            [ _tickerView  reloadItemAtIndex:index];
            break;
        }
    }
    
}


@end
