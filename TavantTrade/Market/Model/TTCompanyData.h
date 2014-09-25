//
//  TTCompanyData.h
//  TavantTrade
//
//  Created by Bandhavi on 1/20/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMPTY_IF_NIL(__STRING) (__STRING ? __STRING : @"")

#define EMPTY_Float_IF_NIL(__float) (__float ? __float : 0.0)

@interface TTCompanyData : NSObject
@property(nonatomic,strong) NSString *scriptCode;
@property(nonatomic,strong) NSString *companyName;
@property(nonatomic,strong) NSString *symbolName;
@property(nonatomic,strong) NSString *companyCode;
@property(nonatomic,strong) NSString *closePrice;
@property(nonatomic,strong) NSString *previousClosePrice;
@property(nonatomic,strong) NSString *netChange;
@property(nonatomic,strong) NSString *percentageChange;
@property(nonatomic,strong) NSString *openPrice;
@property(nonatomic,strong) NSString *highPrice;
@property(nonatomic,strong) NSString *lowPrice;
@property(nonatomic,strong) NSString *volume;

-(id)initWithDictionary:(id)dataDictionary;

@end
