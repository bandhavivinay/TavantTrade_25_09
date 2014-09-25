//
//  TTDiffusionData.m
//  Diffusion_Native
//
//  Created by Bandhavi on 12/10/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTDiffusionData.h"

@implementation TTDiffusionData

@synthesize askValue,bidValue,fiftyTwoWeekHigh,fiftyTwoWeekLow,highPrice,lastSalePrice,lowPrice,netPriceChange,netPriceChangeIndicator,volume,symbolData,closingPrice,openingPrice,topic;

-(id)init{
    self = [super init];
    if(self){
        self.netPriceChangeIndicator = @"+";
        
        return self;
    }
    return nil;
}

-(id)updateDiffusionDataWith:(NSArray *)streamingData{
    
    
//    self.askValue = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headerArray indexOfObject:@"ledgerBalance"]] floatValue]);
//    self.bidValue = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:10] floatValue]);
//    self.fiftyTwoWeekHigh = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:8] floatValue]);
//    self.fiftyTwoWeekLow = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:9] floatValue]);
//    self.highPrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:2] floatValue]);
//    self.lowPrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:3] floatValue]);
//    self.netPriceChange = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:7] floatValue]);
//    self.lastSalePrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:13] floatValue]);
//    self.volume = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:16] floatValue]);
//    self.openingPrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:4] floatValue]);
//    self.closingPrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:5] floatValue]);
//    self.lastTradedTime = EMPTY_IF_NIL([streamingData objectAtIndex:29]);
//    if([EMPTY_IF_NIL([streamingData objectAtIndex:6]) length] == 0)
//        self.netPriceChangeIndicator = @"";
//    else
//        self.netPriceChangeIndicator = EMPTY_IF_NIL([streamingData objectAtIndex:6]);

    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"DiffusionHeader"] count] != 0){
        _headerArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"DiffusionHeader"];
    }
    self.askValue = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headerArray indexOfObject:@"bestOfferPrice"]] floatValue]);
    self.bidValue = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headerArray indexOfObject:@"bestBidPrice"]] floatValue]);
    self.fiftyTwoWeekHigh = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headerArray indexOfObject:@"fiftyTwoWeekHigh"]] floatValue]);
    self.fiftyTwoWeekLow = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headerArray indexOfObject:@"fiftyTwoWeekLow"]] floatValue]);
    self.highPrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headerArray indexOfObject:@"highPrice"]] floatValue]);
    self.lowPrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headerArray indexOfObject:@"lowPrice"]] floatValue]);
    self.netPriceChange = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headerArray indexOfObject:@"netPriceChange"]] floatValue]);
    self.lastSalePrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headerArray indexOfObject:@"lastSalePrice"]] floatValue]);
    self.volume = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headerArray indexOfObject:@"tradeVolume"]] floatValue]);
    self.openingPrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headerArray indexOfObject:@"openingPrice"]] floatValue]);
    self.closingPrice = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headerArray indexOfObject:@"closingPrice"]] floatValue]);
    self.lastTradedTime = EMPTY_IF_NIL([streamingData objectAtIndex:[_headerArray indexOfObject:@"lastSaleTime"]]);
    if([EMPTY_IF_NIL([streamingData objectAtIndex:[_headerArray indexOfObject:@"netChangeIndicator"]]) length] == 0)
        self.netPriceChangeIndicator = @"";
    else
        self.netPriceChangeIndicator = EMPTY_IF_NIL([streamingData objectAtIndex:[_headerArray indexOfObject:@"netChangeIndicator"]]);
    
    self.lastSaleSize = EMPTY_IF_NIL([streamingData objectAtIndex:[_headerArray indexOfObject:@"lastSaleSize"]]);
    
    if([self.lastSaleSize length] == 0)
        self.lastSaleSize = @"0";
    
    self.openInterest = EMPTY_IF_NIL([streamingData objectAtIndex:[_headerArray indexOfObject:@"openInterest"]]);
    
    if([self.openInterest length] == 0)
        self.openInterest = @"0";
    
    self.VWAP = EMPTY_IF_NIL([streamingData objectAtIndex:[_headerArray indexOfObject:@"VWAP"]]);
    self.bestOfferSize = EMPTY_IF_NIL([streamingData objectAtIndex:[_headerArray indexOfObject:@"bestOfferSize"]]);
    
        
    return self;
}

@end
