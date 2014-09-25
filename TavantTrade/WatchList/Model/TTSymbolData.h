//
//  TTSymbolData.h
//  Diffusion_Native
//
//  Created by Bandhavi on 12/10/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTSymbolData : NSObject
@property(nonatomic,strong)NSString *symbolName;
@property(nonatomic,strong)NSString *companyName;
@property(nonatomic,strong)NSString *tradeSymbolName;
@property(nonatomic,strong)NSString *subscriptionKey;
@property(nonatomic,strong)NSString *exchange;
@property(nonatomic,strong)NSString *series;
@property(nonatomic,strong)NSString *expiryDate;
@property(nonatomic,strong)NSString *optionType;
@property(nonatomic,strong)NSString *strikePrice;
@property(nonatomic,strong)NSDictionary *jsonRawDictionary;
@property(nonatomic,strong)NSString *instrumentType;
@property(nonatomic,strong)NSString *symbolToken;
-(id)initWithDictionary:(id)symbolDictionary;
@end
