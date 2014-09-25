//
//  TTAccountDataSource.h
//  TavantTrade
//
//  Created by TAVANT on 2/10/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

#define EMPTY_IF_NIL(__STRING) (__STRING ? __STRING : @"")

#define EMPTY_Float_IF_NIL(__float) (__float ? __float : 0.0)
#import "TTDiffusionData.h"
#import "TTDiffusionHandler.h"

@interface TTAccountDataSource : NSObject
@property(nonatomic,assign)float ledgerBalance;
@property(nonatomic,assign)float  lienedAmount;
//@property(nonatomic,assign)float ipoAmount;
@property(nonatomic,assign)float  mutualFundAmount;
@property(nonatomic,assign)float  IPOAmount;
@property(nonatomic,assign)float  collateral;
@property(nonatomic,assign)float  fundsFormSales;
@property(nonatomic,assign)float  realisedGain;
@property(nonatomic,assign)float  additionAdhocMargin;
@property(nonatomic,assign)float  adhocMargin;
@property(nonatomic,assign)float  nationalCash;
@property(nonatomic,assign)float  directCollateral;
@property(nonatomic,assign)float  mtmLoss;
@property(nonatomic,assign)float  mtmLossOnPositions;
@property(nonatomic,assign)float  amountUnlened;
@property(nonatomic,assign)float  totalMarginUsed;
@property(nonatomic,assign)float  marginUsed;
@property(nonatomic,assign)float  unrealisedMTMLoss;
@property(nonatomic,assign)float  realisedMTMGain;
@property(nonatomic,assign)float cncSales;
@property(nonatomic,assign)float limit;
@property(nonatomic,strong)NSString * type;
//-(id)updateAccountsData:(DFTopicMessage *)streamingData;
-(TTAccountDataSource *) initWithAccountsData:(DFTopicMessage *)message;
-(TTAccountDataSource *) initWithDictionary:(NSDictionary *)dict;

@end
