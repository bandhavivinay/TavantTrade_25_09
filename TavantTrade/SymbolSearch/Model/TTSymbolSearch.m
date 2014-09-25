//
//  TTSymbolSearch.m
//  TavantTrade
//
//  Created by Bandhavi on 12/12/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTSymbolSearch.h"

@implementation TTSymbolSearch
@synthesize companyCode,symbolID,instrumentType,precision,symbolData,tickSize,token,tradeSymbol,series;

-(id)initWithDictionary:(id)symbolDictionary{
    self = [super init];
    if(self){
        
        self.symbolData = [[TTSymbolData alloc] init];
        self.symbolData.symbolToken = symbolDictionary[@"token"];
        
        self.symbolData.companyName = symbolDictionary[@"name"];
        self.symbolData.exchange = symbolDictionary[@"exchange"];
        self.symbolData.symbolName = symbolDictionary[@"sorSymbol"];
        self.symbolData.tradeSymbolName = symbolDictionary[@"tradeSymbol"];
        self.symbolData.subscriptionKey = [NSString stringWithFormat:@"SYMBOLS/QUOTES/%@",symbolDictionary[@"subscriptionKey"]];
        
        self.companyCode = symbolDictionary[@"companyCode"];
        self.tickSize = symbolDictionary[@"tickSize"];
        self.precision = symbolDictionary[@"precision"];
        self.symbolID = [symbolDictionary[@"id"] intValue];
        self.token = [symbolDictionary[@"token"] intValue];
        self.instrumentType = symbolDictionary[@"instrumentType"];
//        self.tradeSymbol = symbolDictionary[@"tradeSymbol"];
        
        //get the series by accessing the last two characters from the tradesymbol...
        
        self.series = [self.symbolData.tradeSymbolName substringFromIndex: [self.symbolData.tradeSymbolName length] - 2];
        
        return self;
    }
    return nil;
}

@end
