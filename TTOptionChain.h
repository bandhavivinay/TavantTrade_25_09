//
//  TTOptionChain.h
//  TavantTrade
//
//  Created by Bandhavi on 3/5/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTCallOption.h"
#import "TTPutOption.h"

#define EMPTY_IF_NIL(__STRING) (__STRING ? __STRING : @"")

@interface TTOptionChain : NSObject

@property(nonatomic,strong)NSString *strikePrice;
@property(nonatomic,strong)NSString *expiryDate;
@property(nonatomic,strong)TTCallOption *callOption;
@property(nonatomic,strong)TTPutOption *putOption;
@property(nonatomic,strong)NSString *selectedOption;


-(id)initWithOCDictionary:(NSDictionary *)inDictionary;

@end
