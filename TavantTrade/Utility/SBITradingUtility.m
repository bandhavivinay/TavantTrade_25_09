//
//  SBITradingUtility.m
//  Diffusion_Native
//
//  Created by Bandhavi on 12/10/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "SBITradingUtility.h"
#import "TTAppDelegate.h"
#import "SBITradingNetworkManager.h"
#import "TTSymbolDetails.h"
#import "UIColor+Additions.h"
@implementation SBITradingUtility

@synthesize loadingView,globalExchangeType,currentSelectedWatchlist,watchlistController;

+ (instancetype)sharedUtility
{
    static SBITradingUtility *utility = nil;
    if(!utility)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            utility = [[super allocWithZone:nil] init];
            
        });
    }
    
    return utility;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void)updateExchangeTypeWith:(EExchangeType)inExchangeType{
    globalExchangeType = inExchangeType;
}

-(EExchangeType)returnCurrentExchangeType{
    return globalExchangeType;
}

+(NSString *)getTitleForWatchlistActionType:(EWatchListActionItems)inActionItem{
    NSString *actionItem = @"";
    switch (inActionItem) {
        case eTradeAction:
        {
            actionItem = @"Trade";
        }
            break;
        case eQuoteAction:
        {
            actionItem = @"Go to Quote";
        }break;
        case eOptionChainAction:
        {
            actionItem = @"Option Chain";
        }
            break;
        case eDeleteSymbolAction:
        {
            actionItem = @"Delete Symbol";
        }
            break;
            
        default:break;
    }
    return actionItem;
}




+(UIWindow *)returnWindowObject{
    return [(TTAppDelegate *)[[UIApplication sharedApplication] delegate] window];
}

-(void)addLoadingSymbol:(BOOL)shouldAdd{
    
    //get the current window...
    
    UIWindow *window = [(TTAppDelegate *)[[UIApplication sharedApplication] delegate] window];
    
    if(shouldAdd == YES){
        [loadingView removeFromSuperview];
        loadingView = nil;
        if(loadingView == nil)
            loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
        
        loadingView.backgroundColor = [UIColor blackColor];
        [loadingView setAlpha:0.5];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.frame = CGRectMake(382, 470, 100, 100);
        [activityIndicator startAnimating];
        [loadingView addSubview:activityIndicator];
        [window addSubview:loadingView];
    }
    else{
        [loadingView removeFromSuperview];
    }
    
}

+(NSArray *)parseArray:(NSArray *)rawArray{

    rawArray = [[rawArray objectAtIndex:0] componentsSeparatedByString:@""];
    return rawArray;
}

+ (NSString *) getTitleForEchangeType:(EExchangeType)inType
{
    NSString *exchangeTitle = @"";
    switch (inType) {
        case eNSE:
        {
            exchangeTitle =NSLocalizedStringFromTable(@"Nse_Exchange", @"Localizable", @"NSE");
        }
            break;
        case eBSE:
        {
            exchangeTitle = NSLocalizedStringFromTable(@"Bse_Exchange", @"Localizable", @"BSE");
        }
            break;
            
        default:
            break;
    }
    return exchangeTitle;
}



+(NSString *)getTitleForInstrumentType:(InstrumentType)instrType{
    NSString *instrumentTitle = @"";
    switch (instrType) {
        case EQUITY:
        {
            instrumentTitle = NSLocalizedStringFromTable(@"Equity", @"Localizable", @"EQUITY");
        }
            break;
        case FUTURE_CURRENCY:
        {
            instrumentTitle = NSLocalizedStringFromTable(@"Future_Currency", @"Localizable", @"FUTURE CURRENCY");
        }
            break;
        case FUTURE_INDEX:
        {
            instrumentTitle = NSLocalizedStringFromTable(@"Future_Index", @"Localizable",@"FUTURE INDEX");
        }
            break;
        case FUTURE_STOCK:
        {
            instrumentTitle = NSLocalizedStringFromTable(@"Future_Stock", @"Localizable", @"FUTURE STOCK");
        }
            break;
        case OPTION_CURRENCY:
        {
            instrumentTitle =NSLocalizedStringFromTable(@"Option_Currency", @"Localizable", @"OPTION CURRENCY") ;
        }
            break;
        case OPTION_INDEX:
        {
            instrumentTitle =NSLocalizedStringFromTable(@"Option_Index", @"Localizable", @"OPTION INDEX") ;
        }
            break;
        case OPTION_STOCK:
        {
            instrumentTitle = NSLocalizedStringFromTable(@"Option_Stock", @"Localizable", @"OPTION STOCK") ;
        }
            break;
        default:
            break;
    }
    return instrumentTitle;
}

+(NSString *)getInstrumentTypeURLKey:(InstrumentType)instrType{
    NSString *instrumentTitle = @"";
    switch (instrType) {
        case EQUITY:
        {
            instrumentTitle = NSLocalizedStringFromTable(@"Equity", @"Localizable", @"EQUITY");
        }
            break;
        case FUTURE_CURRENCY:
        {
            instrumentTitle = NSLocalizedStringFromTable(@"Future_Currency_Url", @"Localizable", @"FUTCUR");
        }
            break;
        case FUTURE_INDEX:
        {
            instrumentTitle = NSLocalizedStringFromTable(@"Future_Index_Url", @"Localizable", @"FUTIDX");
        }
            break;
        case FUTURE_STOCK:
        {
            instrumentTitle = NSLocalizedStringFromTable(@"Future_Stock_Url", @"Localizable", @"FUTSTK");
        }
            break;
        case OPTION_CURRENCY:
        {
            instrumentTitle = NSLocalizedStringFromTable(@"Option_Currency_Url", @"Localizable", @"OPTCUR");
        }
            break;
        case OPTION_INDEX:
        {
            instrumentTitle = NSLocalizedStringFromTable(@"Option_Index_Url", @"Localizable", @"OPTIDX");
        }
            break;
        case OPTION_STOCK:
        {
            instrumentTitle =  NSLocalizedStringFromTable(@"Option_Stock_Url", @"Localizable", @"OPTSTK");;
        }
            break;
        default:
            break;
    }
    return instrumentTitle;
}

+(NSString *)getWatchlistKey:(EWatchlistColumns)watchlistColumn{
    NSString *key = @"";
    switch (watchlistColumn) {
        case eLastTradedSize:
        {
            key = @"lastSaleSize";
        }
            break;
        case eOI:
        {
            key = @"openInterest";
        }
            break;
        case eVWAP:
        {
            key = @"VWAP";
        }
            break;
        case eOfferSize:
        {
            key = @"bestOfferSize";
        }
            break;
        case eExpiryDate:
        {
            key = @"symbolData.expiryDate";
        }
            break;
        case eInstrument:
        {
            key = @"symbolData.instrumentType";
        }
            break;
        case eOptType:
        {
            key = @"symbolData.optionType";
        }
            break;
        case eStrike:
        {
            key = @"symbolData.strikePrice";
        }
            break;
        default:
            break;
    }
    return key;
}


+(NSString *)getExchangeTypeURLKey:(EExchangeType)exchangeType{
    NSString *exchangeTitle = @"";
    switch (exchangeType) {
        case eNSE:
        {
            exchangeTitle = NSLocalizedStringFromTable(@"Nse_Exchange", @"Localizable", @"NSE");
        }
            break;
        case eBSE:
        {
            exchangeTitle = NSLocalizedStringFromTable(@"Bse_Exchange", @"Localizable", @"BSE");
        }
            break;
        default:
            break;
    }
    return exchangeTitle;
}

+ (NSString *) getTitleForMarketDataType:(MarketDataType)inMarketType{
    NSString *marketTitle = @"";
    switch (inMarketType) {
        case HOURLY_GAINER:
        {
            marketTitle =  NSLocalizedStringFromTable(@"Hourly_Gainers", @"Localizable", @"Hourly Gainer");
        }
            break;
        case HOURLY_LOSER:
        {
            marketTitle = NSLocalizedStringFromTable(@"Hourly_Losers", @"Localizable",@"Hourly Losers");
        }
            break;
        case TOP_GAINER:
        {
            marketTitle = NSLocalizedStringFromTable(@"Top_Gainers", @"Localizable",@"Top Gainers");
        }
            break;
        case TOP_LOSER:
        {
            marketTitle = NSLocalizedStringFromTable(@"Top_Losers", @"Localizable",@"Top Losers");
        }
            break;
        case PRICE_SHOCKER:
        {
            marketTitle = NSLocalizedStringFromTable(@"Price_Shockers", @"Localizable",@"Price Shockers");
        }
            break;
        case VOL_SHOCKER:
        {
            marketTitle = NSLocalizedStringFromTable(@"Volume_Shockers", @"Localizable",@"Volume Shockers");
        }
            break;
        case VOL_TOPPER:
        {
            marketTitle =  NSLocalizedStringFromTable(@"Volume_Toppers", @"Localizable",@"Volume Toppers");
        }
            break;
        case MOST_ACTIVE:
        {
            marketTitle = NSLocalizedStringFromTable(@"Most_Actives", @"Localizable",@"Most Actives");
        }
            break;
        default:
            break;
    }
    return marketTitle;

}

+(NSString *)getMarketDataTypeURLKey:(MarketDataType)inMarketType{
    NSString *marketTypeURLString = @"";
    switch (inMarketType) {
        case HOURLY_GAINER:
        {
            marketTypeURLString = NSLocalizedStringFromTable(@"Hourly_Gainers_Url", @"Localizable",@"hourlygl");
          
        }
            break;
        case HOURLY_LOSER:
        {
            marketTypeURLString = NSLocalizedStringFromTable(@"Hourly_Gainers_Url", @"Localizable",@"hourlygl");
        }
            break;
        case TOP_GAINER:
        {
            marketTypeURLString = NSLocalizedStringFromTable(@"Top_Gainers_Url", @"Localizable",@"gainerloser");
        }
            break;
        case TOP_LOSER:
        {
            marketTypeURLString = NSLocalizedStringFromTable(@"Top_Gainers_Url", @"Localizable",@"gainerloser");
        }
            break;
        case PRICE_SHOCKER:
        {
            marketTypeURLString = NSLocalizedStringFromTable(@"Price_Shockers_Url", @"Localizable",@"priceshocker");
        }
            break;
        case VOL_SHOCKER:
        {
            marketTypeURLString = NSLocalizedStringFromTable(@"Volume_Shockers_Url", @"Localizable",@"volumeshocker");
        }
            break;
        case VOL_TOPPER:
        {
            marketTypeURLString = NSLocalizedStringFromTable(@"Volume_Toppers_Url", @"Localizable",@"topper");
        }
            break;
        case MOST_ACTIVE:
        {
            marketTypeURLString = NSLocalizedStringFromTable(@"Most_Actives_Url", @"Localizable",@"active");
        }
            break;
        default:
            break;
    }
    return marketTypeURLString;
}

+(NSString *)getQueryTypeString:(ESOAPRequestType)inRequestType{
    NSString *queryString = @"";
    switch (inRequestType) {
        case eFeedbackQRC:
        {
            queryString = @"Others";
        }
            break;
        case eClientStatus:
        {
            queryString = @"Customer Related Query";
        }
            break;
        case eLeadStatus:
        {
            queryString = @"Lead Type Query";
        }
            break;
        default:
            break;
    }
    return queryString;
}

+(NSString *)getTitleForTransactionType:(ETransactionType)transType{
    NSString *transactionTitle = @"";
    switch (transType) {
        case eBuy:
        {
            transactionTitle = NSLocalizedStringFromTable(@"Buy_Type", @"Localizable",@"Buy");
        }
            break;
        case eSell:
        {
            transactionTitle = NSLocalizedStringFromTable(@"Sell_Type", @"Localizable",@"Sell");
        }
        default:break;
    }
    return transactionTitle;
}

+(NSString *)getTitleForOrderType:(EOrderType)ordType{
    NSString *orderTitle = @"";
    switch (ordType) {
        case eLimitType:
        {
            orderTitle = NSLocalizedStringFromTable(@"Limit_Order_Title", @"Localizable",@"Limit");
        }
            break;
        case eMarketType:
        {
            orderTitle = NSLocalizedStringFromTable(@"Market_Order_Title", @"Localizable",@"Market");
        }break;
        case eSLLType:
        {
            orderTitle = NSLocalizedStringFromTable(@"SLL_Order_Title", @"Localizable",@"SL-L");
        }
            break;
        case eSLMType:
        {
            orderTitle = NSLocalizedStringFromTable(@"SLM_Order_Title", @"Localizable",@"SL-M");
        }
            
        default:break;
    }
    return orderTitle;
}


+(float)getWatchlistColumnWidthFor:(EWatchlistColumns)inColumn{
    float columnWidth = 0.0;
    switch (inColumn) {
        case eExpiryDate:
        case eLastTradedSize:
        case eLCL:
        case eUCL:
            columnWidth = 126.0;
            break;
        case eOfferSize:
        case eOffer:
        case eInstrument:
        case eStrike:
        case eRollingOI:
        case eOptType:
        case eUnderlier:
        case eVWAP:
            columnWidth = 65.0;
            break;
        default:
            break;
    }
    return columnWidth;
}


+(void)searchSymbolWithText:(NSString *)searchText WithExchangeType:(EExchangeType)inExchangeType andInstrumentType:(InstrumentType)inIntrumentType{
    //get the list of symbols after the search...
    NSLog(@"Search Text %@",searchText);
    dispatch_queue_t customQueue = dispatch_queue_create("com.SBITrading.queue", NULL);
    NSMutableArray *symbolResultArray = [[NSMutableArray alloc] init];
    
    dispatch_sync(customQueue, ^{
        if([searchText length] > 0){
            NSString *exchangeTypeString = [SBITradingUtility getTitleForEchangeType:inExchangeType];
            NSString *relativePathString = [NSString stringWithFormat:@"/instruments/%@/%@/%@",searchText,exchangeTypeString
                                            ,[SBITradingUtility getInstrumentTypeURLKey:inIntrumentType]];
            NSLog(@"Request URL is %@",relativePathString);
            SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
            __block TTSymbolData *currentSymbolData;
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
                    currentSymbolData = [symbolResultArray objectAtIndex:0];
                    TTSymbolDetails *searchSymbol = [TTSymbolDetails sharedSymbolDetailsManager];
                    searchSymbol.symbolData = currentSymbolData;
                    
                    [SBITradingUtility getSymbolDetailsForSymbol:searchSymbol.symbolData withExchange:inExchangeType andInstrumentType:inIntrumentType];
                    
                    
                }
            }];
        }

    });
    
    
}

+(void)getSymbolDetailsForSymbol:(TTSymbolData *)inSymbolData withExchange:(EExchangeType)inExchangeType andInstrumentType:(InstrumentType)inInstrumentType{
    //get the detailed data of the symbol ...
//    TTSymbolDetails *searchSymbol = [TTSymbolDetails sharedSymbolDetailsManager];
    NSString *relativePathString = [NSString stringWithFormat:@"/instruments/%@/%@/%@/%@/null/null/0",inSymbolData.symbolName,[SBITradingUtility getTitleForEchangeType:inExchangeType],[SBITradingUtility getInstrumentTypeURLKey:inInstrumentType],inSymbolData.series];
    NSLog(@"Request URL is %@",relativePathString);
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    
    __block TTSymbolData * symbolData = inSymbolData;
    
    [networkManager makeGETRequestWithRelativePath:relativePathString responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        //            NSLog(@"data is %d",data.length);
        if([data length] > 0){
            NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"%@ and status code is %@",jsonString,response);
            NSError *jsonParsingError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            //                NSLog(@"Symbol Search Instrument is %@",responseDictionary);
            
            if([responseDictionary count] > 0){
                
                symbolData = [[TTSymbolData alloc] initWithDictionary:responseDictionary];
                symbolData.jsonRawDictionary = responseDictionary;
                    
            }
            
            TTSymbolDetails *searchSymbol = [TTSymbolDetails sharedSymbolDetailsManager];
            searchSymbol.symbolData = symbolData;

        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGlobalSymbol" object:nil];
    }];

}

#pragma mark- Symbol Data

+(void)getSymbolDataForSymbolName:(NSString *)inSymbolName withExchange:(NSString *)inExchangeType andInstrumentType:(NSString *)inInstrumentType :(void(^)(id, NSError *))handler{
    //get the detailed data of the symbol ...
    
    NSString *relativePathString = [NSString stringWithFormat:@"/instruments/%@/%@/%@/%@/null/null/0",inSymbolName,inExchangeType,inInstrumentType,@"EQ"];
    NSLog(@"Request URL is %@",relativePathString);
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    
    __block TTSymbolData * symbolData = nil;
    
    [networkManager makeGETRequestWithRelativePath:relativePathString responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        //            NSLog(@"data is %d",data.length);
        if([data length] > 0){
            NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"%@ and status code is %@",jsonString,response);
            NSError *jsonParsingError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            //                NSLog(@"Symbol Search Instrument is %@",responseDictionary);
            
            if([responseDictionary count] > 0){
                
                symbolData = [[TTSymbolData alloc] initWithDictionary:responseDictionary];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(symbolData,error);
                });
                
            }
            else {
                
            }
            
            
        }
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGlobalSymbol" object:nil];
    }];
}

+(NSString *)getTitleForProductType:(EProductType)prodType{
    NSString *prodTitle = @"";
    switch (prodType) {
        case eIntraday:
        {
            prodTitle =  @"Intraday";//NSLocalizedStringFromTable(@"Intraday_Prod_Type", @"Localizable",@"IntraDay");
        }
            break;
        case eDelivery:
        {
            prodTitle = NSLocalizedStringFromTable(@"Delivery_Prod_Type", @"Localizable",@"Delivery");
        }
               default:break;
    }
    return prodTitle;
}
+(NSString *)getTitleForDuration:(EDuration)duration{
    NSString *durTitle = @"";
    switch (duration) {
        case eDay:
        {
            durTitle = NSLocalizedStringFromTable(@"Dur_Day", @"Localizable",@"Day");
        }
            break;
        case eIOC:
        {
            durTitle = NSLocalizedStringFromTable(@"Dur_Ioc", @"Localizable",@"IOC");
        }
            
        default:break;
    }
    return durTitle;
}

+(EOrderType)returnOrderType:(NSString *)inOrderType{
    if([inOrderType caseInsensitiveCompare:NSLocalizedStringFromTable(@"Limit_Order_Title", @"Localizable",@"Limit")] == NSOrderedSame){
        return eLimitType;
    }
    else if([inOrderType caseInsensitiveCompare:NSLocalizedStringFromTable(@"Market_Order_Title", @"Localizable",@"Market")] == NSOrderedSame){
        return eMarketType;
    }
    else if([inOrderType caseInsensitiveCompare:NSLocalizedStringFromTable(@"SLL_Order_Title", @"Localizable",@"SL-L")] == NSOrderedSame){
        return eSLLType;
    }
    else
        return eSLMType;
        
}

+(NSString *)getLimitType:(ELimits)limits{
    NSString *limitType = @"";
    switch (limits) {
        case eCash:
        {
            limitType =  NSLocalizedStringFromTable(@"Cash_Limit", @"Localizable",@"IOC");
        }
            break;
        case eClient:
        {
            limitType = NSLocalizedStringFromTable(@"Client_Limit", @"Localizable",@"Client");
        }
        case eFo:
        {
            limitType =NSLocalizedStringFromTable(@"Fo_Limit", @"Localizable",@"FO");
        }
            break;
        case eCur:
        {
            limitType = NSLocalizedStringFromTable(@"Cur_Limit", @"Localizable",@"Currency");
        }
            
        default:break;
    }
    return limitType;
}

+(NSString *)plistFilePath {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    
    return path;

}

+ (UIColor *)getColorForComponentKey:(NSString *)inComponent
{
    UIColor *componentColor = [UIColor clearColor];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:[self plistFilePath]];
    
    NSString *colorString = [[dict objectForKey:@"Color"] objectForKey:inComponent];
    
    componentColor = [UIColor colorWithHexValue:colorString];
    
    
    return componentColor;
}

+(NSDate *)returnDateWithTimeFrom:(NSString *)dateString{
    
    NSString * timeStampString = dateString;
    NSTimeInterval _interval=[timeStampString doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd/MM/yyyy, hh:mm a"];
    NSString *_date=[_formatter stringFromDate:date];
    NSLog(@"%@",_date);
    return date;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd/MM/yyyy,HH:mm:ss"];
//    NSDate *dateFromString = [[NSDate alloc] init];
//    dateFromString = [dateFormatter dateFromString:dateString];
//    return dateFromString;
}

+(NSDate *)returnDateWithoutTimeFrom:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}

+(NSString *)returnStringFromDate:(NSDate *)inDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy, hh:mm a"];
    NSString *stringFromDate = @"";
    stringFromDate = [dateFormatter stringFromDate:inDate];
    return stringFromDate;
}

//+(UIFont *)navBarHeadingFont{
//    return [UIFont fontWithName:@"OpenSans-Semibold" size:22.0f];
//}

//+(UIFont *)widgetNavBarHeadingFont{
//    return [UIFont fontWithName:@"OpenSans-Semibold" size:19.0f];
//}

//+(UIFont *)tickerFont{
//    return [UIFont fontWithName:@"OpenSans-Semibold" size:12.0f];
//}

//+(UIFont *)watchlistValueFont{
//    return [UIFont fontWithName:@"OpenSans-Semibold" size:12.0f];
//}

//+(UIFont *)watchlistTitleFont{
//    return [UIFont fontWithName:@"OpenSans-Semibold" size:10.0f];
//}

//+(UIFont *)symbolNameFont{
//    return [UIFont fontWithName:@"OpenSans-Semibold" size:14.0f];
//}

//+(UIFont *)cancelButtonFont{
//    return [UIFont fontWithName:@"OpenSans-Semibold" size:15.5f];
//}

//+(UIFont *)fontWithSize17{
//    return [UIFont fontWithName:@"OpenSans-Semibold" size:17.0f];
//}

//+(UIFont *)semiBoldFontWithSize16{
//    return [UIFont fontWithName:@"OpenSans-Semibold" size:16.0f];
//}

//+(UIFont *)semiBoldFontWithSize15{
//    return [UIFont fontWithName:@"OpenSans-Semibold" size:15.0f];
//}

//+(UIFont *)semiBoldFontWithSize14{
//    return [UIFont fontWithName:@"OpenSans-Semibold" size:14.0f];
//}

//+(UIFont *)semiBoldFontWithSize13{
//    return [UIFont fontWithName:@"OpenSans-Semibold" size:13.0f];
//}

//+(UIFont *)regularFontWithSize13{
//    return [UIFont fontWithName:@"OpenSans" size:13.0f];
//}

//+(UIFont *)regularFontWithSize11{
//    return [UIFont fontWithName:@"OpenSans" size:11.0f];
//}

//+(UIFont *)regularFontWithSize16{
//    return [UIFont fontWithName:@"OpenSans" size:16.0f];
//}

//+(UIFont *)regularFontWithSize15{
//    return [UIFont fontWithName:@"OpenSans" size:15.0f];
//}

//+(UIFont *)regularFontWithSize14{
//    return [UIFont fontWithName:@"OpenSans" size:14.0f];
//}


@end
