//
//  TTMapData.h
//  TavantTrade
//
//  Created by Bandhavi on 5/21/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTConstants.h"

@interface TTMapData : NSObject
@property(nonatomic,strong)NSString *symbolName;
@property(nonatomic,assign)EExchangeType exchangeType;
@property(nonatomic,strong)NSString *companyName;
@property(nonatomic,strong)NSNumber *percentageChange;
@property(nonatomic,strong)NSNumber *netChange;
@property(nonatomic,strong)NSNumber *turnover;
@property(nonatomic,strong)NSNumber *OIChange;
@property(nonatomic,strong)NSNumber *volume;

-(id)initWithDictionary:(id)mapDictionary;

@end
