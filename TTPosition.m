//
//  TTPosistion.m
//  TavantTrade
//
//  Created by administrator on 05/08/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTPosition.h"

@implementation TTPosition

-(id)initWithDictionary:(id)positionsDataDictionary{
    self = [super init];
    if(self){
//        self.symbolName = EMPTY_IF_NIL(positionsDataDictionary[@"symbolName"]);
//        self.ltp = EMPTY_IF_NIL(positionsDataDictionary[@"ltp"]);
//        self.averageCost = EMPTY_IF_NIL(positionsDataDictionary[@"averageCost"]);
//        self.profitAmount = EMPTY_IF_NIL(positionsDataDictionary[@"profitAmount"]);
//        self.profitPercentage = EMPTY_IF_NIL(positionsDataDictionary[@"profitPercentage"]);
//        self.quantity = EMPTY_IF_NIL(positionsDataDictionary[@"quantity"]);
//        self.type = EMPTY_IF_NIL(positionsDataDictionary[@"type"]);
        
        //self.lastTradedPrice = 1.0;
        
        self.msgType = EMPTY_IF_NIL(positionsDataDictionary[@"msgType"]);
        self.account = EMPTY_IF_NIL(positionsDataDictionary[@"account"]);
        self.clientID = EMPTY_IF_NIL(positionsDataDictionary[@"clientID"]);
        self.sequenceNumber = EMPTY_IF_NIL(positionsDataDictionary[@"sequenceNumber"]);
        self.noOfMessages = EMPTY_IF_NIL(positionsDataDictionary[@"noOfMessages"]);
        self.requestId = EMPTY_IF_NIL(positionsDataDictionary[@"requestId"]);
        self.uniqueId = EMPTY_IF_NIL(positionsDataDictionary[@"uniqueId"]);
        self.subscriptionKey = EMPTY_IF_NIL(positionsDataDictionary[@"subscriptionKey"]);
        self.exchange = EMPTY_IF_NIL(positionsDataDictionary[@"exchange"]);
        self.token = EMPTY_IF_NIL(positionsDataDictionary[@"token"]);
        self.productType = EMPTY_IF_NIL(positionsDataDictionary[@"productType"]);
        self.symbol = EMPTY_IF_NIL(positionsDataDictionary[@"symbol"]);
        self.instrumentType = EMPTY_IF_NIL(positionsDataDictionary[@"instrumentType"]);
        
        self.buyQty = EMPTY_Number_IF_NIL(positionsDataDictionary[@"buyQty"]);
        self.sellQty = EMPTY_Number_IF_NIL(positionsDataDictionary[@"sellQty"]);
        self.buyAmount = EMPTY_Number_IF_NIL(positionsDataDictionary[@"buyAmount"]);
        self.sellAmount = EMPTY_Number_IF_NIL(positionsDataDictionary[@"sellAmount"]);
        
        self.type = EMPTY_IF_NIL(positionsDataDictionary[@"type"]);
        self.netQty = EMPTY_IF_NIL(positionsDataDictionary[@"netQty"]);
        self.netAmt = EMPTY_IF_NIL(positionsDataDictionary[@"netAmt"]);
        self.averagePrice = EMPTY_IF_NIL(positionsDataDictionary[@"averagePrice"]);
        self.cfBuyQty = EMPTY_IF_NIL(positionsDataDictionary[@"cfBuyQty"]);
        self.cfSellQty = EMPTY_IF_NIL(positionsDataDictionary[@"cfSellQty"]);
        self.cfBuyAmount = EMPTY_IF_NIL(positionsDataDictionary[@"cfBuyAmount"]);
        self.cfSellAmount = EMPTY_IF_NIL(positionsDataDictionary[@"cfSellAmount"]);
        self.cfNetQty = EMPTY_IF_NIL(positionsDataDictionary[@"cfNetQty"]);
        self.cfNetAmount = EMPTY_IF_NIL(positionsDataDictionary[@"cfNetAmount"]);
        self.cfAveragePrice = EMPTY_IF_NIL(positionsDataDictionary[@"cfAveragePrice"]);
        self.subKey = [NSString stringWithFormat:@"SYMBOLS/QUOTES/%@",EMPTY_IF_NIL(positionsDataDictionary[@"subKey"])];
        
        self.totalBuyQty = EMPTY_Number_IF_NIL(positionsDataDictionary[@"totalBuyQty"]);
        self.totalSellQty = EMPTY_Number_IF_NIL(positionsDataDictionary[@"totalSellQty"]);
        self.totalBuyAmount = EMPTY_Number_IF_NIL(positionsDataDictionary[@"totalBuyAmount"]);
        self.totalSellAmount = EMPTY_Number_IF_NIL(positionsDataDictionary[@"totalSellAmount"]);
        self.totalNetAmount = EMPTY_Number_IF_NIL(positionsDataDictionary[@"totalNetAmount"]);
        self.totalNetQuantity = EMPTY_Number_IF_NIL(positionsDataDictionary[@"totalNetQuantity"]);
        self.averageSellPrice = EMPTY_Number_IF_NIL(positionsDataDictionary[@"averageSellPrice"]);
        self.averageBuyPrice = EMPTY_Number_IF_NIL(positionsDataDictionary[@"averageBuyPrice"]);
        
        
        
        return self;
    }
    return nil;
}


@end