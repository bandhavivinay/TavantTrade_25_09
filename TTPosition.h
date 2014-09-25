//
//  TTPosistion.h
//  TavantTrade
//
//  Created by administrator on 05/08/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTDiffusionData.h"

@interface TTPosition : NSObject
//@property(nonatomic,strong)NSString *symbolName;
//@property(nonatomic,strong)NSString *ltp;
//@property(nonatomic,strong)NSString *averageCost;
//@property(nonatomic,strong)NSString *quantity;
//@property(nonatomic,strong)NSString *profitPercentage;
//@property(nonatomic,strong)NSString *profitAmount;
//@property(nonatomic,strong)NSString *type;


/***************/
 @property(nonatomic,strong)NSString *msgType;
 @property(nonatomic,strong)NSString *account;
 @property(nonatomic,strong)NSString *clientID;
 @property(nonatomic,strong)NSString *sequenceNumber;
 @property(nonatomic,strong)NSString *noOfMessages;
 @property(nonatomic,strong)NSString *requestId;
 @property(nonatomic,strong)NSString *uniqueId;
 @property(nonatomic,strong)NSString *subscriptionKey;
 @property(nonatomic,strong)NSString *exchange;
 @property(nonatomic,strong)NSString *token;
 @property(nonatomic,strong)NSString *productType;
 @property(nonatomic,strong)NSString *symbol;
 @property(nonatomic,strong)NSString *instrumentType;
 @property(nonatomic,strong)NSNumber *buyQty;
 @property(nonatomic,strong)NSNumber *sellQty;
 @property(nonatomic,strong)NSNumber *buyAmount;
 @property(nonatomic,strong)NSNumber *sellAmount;
 @property(nonatomic,strong)NSString *type;
 @property(nonatomic,strong)NSString *netQty;
 @property(nonatomic,strong)NSString *netAmt;
 @property(nonatomic,strong)NSString *averagePrice;
 @property(nonatomic,strong)NSString *cfBuyQty;
 @property(nonatomic,strong)NSString *cfSellQty;
 @property(nonatomic,strong)NSString *cfBuyAmount;
 @property(nonatomic,strong)NSString *cfSellAmount;
 @property(nonatomic,strong)NSString *cfNetQty;
 @property(nonatomic,strong)NSString *cfNetAmount;
 @property(nonatomic,strong)NSString *cfAveragePrice;
 @property(nonatomic,strong)NSString *subKey;
 @property(nonatomic,strong)NSNumber *totalBuyQty;
 @property(nonatomic,strong)NSNumber *totalSellQty;
 @property(nonatomic,strong)NSNumber *totalBuyAmount;
 @property(nonatomic,strong)NSNumber *totalSellAmount;
 @property(nonatomic,strong)NSNumber *totalNetAmount;
 @property(nonatomic,strong)NSNumber *totalNetQuantity;
 @property(nonatomic,strong)NSNumber *averageSellPrice;
 @property(nonatomic,strong)NSNumber *averageBuyPrice;

@property(nonatomic,assign)float profit;
@property(nonatomic,assign)float profitPercentage;
@property(nonatomic,assign)float lastTradedPrice;
 
 /**********/

-(id)initWithDictionary:(id)positionsDataDictionary;
@end
