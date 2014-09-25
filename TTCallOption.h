//
//  TTCallOption.h
//  TavantTrade
//
//  Created by Bandhavi on 3/10/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMPTY_Float_IF_NIL(__float) (__float ? __float : 0.0)

@interface TTCallOption : NSObject
@property(nonatomic,assign)float callsVolume;
@property(nonatomic,assign)float callsOI;
@property(nonatomic,assign)float callsBidValue;
@property(nonatomic,assign)float callsAskValue;
@property(nonatomic,assign)float callsLTP;
@property(nonatomic,strong)NSString *callsSubscriptionKey;

-(id)updateWithCallsDictionary:(NSArray *)streamingData;

@end
