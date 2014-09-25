//
//  TTSymbolSearch.h
//  TavantTrade
//
//  Created by Bandhavi on 12/12/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTSymbolData.h"

#define EMPTY_IF_NIL(__STRING) (__STRING ? __STRING : @"")

@interface TTSymbolSearch : NSObject
@property(nonatomic,strong)TTSymbolData *symbolData;
@property(nonatomic,strong)NSString *instrumentType;
@property(nonatomic,strong)NSString *tradeSymbol;
@property(nonatomic,strong)NSString *companyCode;
@property(nonatomic,strong)NSString *tickSize;
@property(nonatomic,strong)NSString *precision;
@property(nonatomic,assign)int symbolID;
@property(nonatomic,strong)NSString *series;
@property(nonatomic,assign)int token;
-(id)initWithDictionary:(id)symbolDictionary;
@end
