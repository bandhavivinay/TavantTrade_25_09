//
//  TTOrder.h
//  TavantTrade
//
//  Created by Bandhavi on 2/17/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTSymbolData.h"

#define EMPTY_IF_NIL(__STRING) (__STRING ? __STRING : @"")

@interface TTOrder : NSObject
@property(nonatomic,strong)NSString *account;
@property(nonatomic,strong)NSString *isAmo;
@property(nonatomic,strong)NSString *clientID;
@property(nonatomic,strong)NSDate *confirmDate;
@property(nonatomic,assign)int disclosedQuantity;
@property(nonatomic,strong)NSString *exchangeOrderID;
@property(nonatomic,strong)NSString *exchangeType;
@property(nonatomic,strong)NSString *instrumentType;
@property(nonatomic,strong)NSString *messageType;
@property(nonatomic,strong)NSString *orderDuration;
@property(nonatomic,strong)NSString *priceType;
@property(nonatomic,strong)NSString *productType;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)TTSymbolData *symbolData;
//@property(nonatomic,strong)NSString *symbolName;
//@property(nonatomic,strong)NSString *tradeSymbolName;
//@property(nonatomic,strong)NSString *companyName;
@property(nonatomic,strong)NSString *transactionType;
@property(nonatomic,assign)int quantitytoFill;
@property(nonatomic,assign)double priceToFill;
@property(nonatomic,strong)NSString *rejectionReason;
@property(nonatomic,strong)NSString *subscriptionKey;
@property(nonatomic,strong)NSString *orderID;
@property(nonatomic,assign)double triggeredPrice;

@property(nonatomic,strong)NSString *orderType;
@property(nonatomic,strong)NSString *durationType;
@property(nonatomic,strong)NSString *origClOrdID;
//@property(nonatomic,strong)NSString *nestRequestId;

//@property(nonatomic,strong)TTSymbolData *symbolData;

-(id)initWithOrderDictionary:(NSDictionary *)inDictionary;

@end
