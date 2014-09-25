//
//  TTSymbolData.m
//  Diffusion_Native
//
//  Created by Bandhavi on 12/10/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTSymbolData.h"
#import "TTConstants.h"

@implementation TTSymbolData
@synthesize symbolName,exchange,subscriptionKey,companyName,jsonRawDictionary,tradeSymbolName,series,expiryDate,optionType,strikePrice;

-(id)initWithDictionary:(id)symbolDictionary{
    self = [super init];
    if(self){
        self.companyName = symbolDictionary[@"name"];
        self.subscriptionKey = [NSString stringWithFormat:@"SYMBOLS/QUOTES/%@",symbolDictionary[@"subscriptionKey"]];
        self.exchange = symbolDictionary[@"exchange"];
        self.symbolName = symbolDictionary[@"sorSymbol"];
        self.tradeSymbolName = symbolDictionary[@"tradeSymbol"];
        
        if(symbolDictionary[@"expiryDate"] == [NSNull null])
            self.expiryDate = @"NA";
        else
            self.expiryDate = EMPTY_IF_NIL(symbolDictionary[@"expiryDate"]);
        
        if(symbolDictionary[@"optionType"] == [NSNull null])
            self.optionType = @"NA";
        else
            self.optionType = EMPTY_IF_NIL(symbolDictionary[@"optionType"]);
        
        if(symbolDictionary[@"strikePrice"] == [NSNull null])
            self.strikePrice = @"NA";
        else
            self.strikePrice = EMPTY_IF_NIL(symbolDictionary[@"strikePrice"]);
        
        self.instrumentType = symbolDictionary[@"instrumentType"];
        self.symbolToken = symbolDictionary[@"token"];
        //get the series by accessing the last two characters from the tradesymbol...
        NSLog(@"Self.series %@",self.tradeSymbolName);
        
        //TODO:Bandhavi
        //self.se
        self.series = [self.tradeSymbolName substringFromIndex: [self.tradeSymbolName length] - 2];
        NSLog(@"Passed with series %@ ... trade symbol name %@",self.series,self.tradeSymbolName);
        
        return self;
    }
    return nil;
}

@end
