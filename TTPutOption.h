//
//  TTPutOption.h
//  TavantTrade
//
//  Created by Bandhavi on 3/10/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMPTY_Float_IF_NIL(__float) (__float ? __float : 0.0)

@interface TTPutOption : NSObject
@property(nonatomic,assign)float putsVolume;
@property(nonatomic,assign)float putsOI;
@property(nonatomic,assign)float putsBidValue;
@property(nonatomic,assign)float putsAskValue;
@property(nonatomic,assign)float putsLTP;
@property(nonatomic,strong)NSString *putsSubscriptionKey;

-(id)updateWithPutsDictionary:(NSArray *)streamingData;

@end
