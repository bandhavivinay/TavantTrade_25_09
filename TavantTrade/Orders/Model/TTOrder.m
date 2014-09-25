//
//  TTOrder.m
//  TavantTrade
//
//  Created by Bandhavi on 2/17/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTOrder.h"
#import "SBITradingUtility.h"

@implementation TTOrder

-(id)initWithOrderDictionary:(NSDictionary *)inDictionary{
    self = [super init];
    if(self){
        self.symbolData = [[TTSymbolData alloc] init];
        self.account = EMPTY_IF_NIL(inDictionary[@"account"]);
        self.clientID = EMPTY_IF_NIL(inDictionary[@"clientID"]);
        //Testing ...
//        self.confirmDate = [SBITradingUtility returnDateWithTimeFrom:EMPTY_IF_NIL(inDictionary[@"secSinceBOE"])];
        self.confirmDate = [SBITradingUtility returnDateWithTimeFrom:EMPTY_IF_NIL(inDictionary[@"transactTime"])];
        //self.confirmDate = EMPTY_IF_NIL(inDictionary[@"confirmDate"]);
        self.clientID = EMPTY_IF_NIL(inDictionary[@"clientID"]);
        self.disclosedQuantity = [EMPTY_IF_NIL(inDictionary[@"disclosedQty"]) intValue];
//        self.exchangeType = EMPTY_IF_NIL(inDictionary[@"exchange"]);
        self.exchangeType = EMPTY_IF_NIL(inDictionary[@"iDSource"]);
        
        self.messageType = EMPTY_IF_NIL(inDictionary[@"msgType"]);
//        self.orderDuration = EMPTY_IF_NIL(inDictionary[@"orderDuration"]);
        self.orderDuration = EMPTY_IF_NIL(inDictionary[@"timeInForce"]);
        self.priceToFill = [EMPTY_IF_NIL(inDictionary[@"price"]) doubleValue];
//        self.priceType = EMPTY_IF_NIL(inDictionary[@"priceType"]);
        self.priceType = EMPTY_IF_NIL(inDictionary[@"ordType"]);
        self.productType = EMPTY_IF_NIL(inDictionary[@"productType"]);
        self.instrumentType = EMPTY_IF_NIL(inDictionary[@"securityType"]);
        
//        self.durationType = EMPTY_IF_NIL(inDictionary[@"durationType"]);
//        self.orderType = EMPTY_IF_NIL(inDictionary[@"orderType"]);
        
       // NSLog(@"%d",isNULL(inDictionary[@"qtyToFill"])) ;
        
        if([[inDictionary valueForKey:@"orderQty"] isEqual:[NSNull null]]){
            self.quantitytoFill = 0;
        }
        else{
            self.quantitytoFill = [EMPTY_IF_NIL(inDictionary[@"orderQty"]) intValue];
        }
        
//        self.status = EMPTY_IF_NIL(inDictionary[@"status"]);
        self.status = EMPTY_IF_NIL(inDictionary[@"ordStatus"]);
        self.symbolData.tradeSymbolName = EMPTY_IF_NIL(inDictionary[@"displaySymbol"]);
        NSString *tempSymbolName = @"";
        NSScanner *scanner = [NSScanner scannerWithString:self.symbolData.tradeSymbolName];
        [scanner scanUpToString:@"-" intoString:&tempSymbolName];
        self.symbolData.symbolName = tempSymbolName;
//        self.symbolName = EMPTY_IF_NIL(inDictionary[@"symbol"]);
//        self.transactionType = EMPTY_IF_NIL(inDictionary[@"transactionType"]);
        self.transactionType = EMPTY_IF_NIL(inDictionary[@"side"]);
        self.rejectionReason = EMPTY_IF_NIL(inDictionary[@"ordRejReason"]);
        //self.transactionType = EMPTY_IF_NIL(inDictionary[@"transactionType"]);
        self.subscriptionKey = EMPTY_IF_NIL(inDictionary[@"subscriptionKey"]);
        self.orderID = EMPTY_IF_NIL(inDictionary[@"orderID"]);
        self.isAmo = ([EMPTY_IF_NIL(inDictionary[@"amo"]) isEqualToString:@"YES"])?@"true":@"false";
        self.triggeredPrice = [EMPTY_IF_NIL(inDictionary[@"triggerPrice"]) doubleValue];
        self.symbolData.companyName = EMPTY_IF_NIL(inDictionary[@"companyName"]);
        self.origClOrdID = EMPTY_IF_NIL(inDictionary[@"origClOrdID"]);
      //  self.nestRequestId = EMPTY_IF_NIL(inDictionary[@"nestRequestId"]);
        return self;
    }
    return nil;

}




@end
