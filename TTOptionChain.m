//
//  TTOptionChain.m
//  TavantTrade
//
//  Created by Bandhavi on 3/5/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTOptionChain.h"

@implementation TTOptionChain

-(id)initWithOCDictionary:(NSDictionary *)inDictionary{
    self = [super init];
    if(self){
        
        self.callOption = [[TTCallOption alloc] init];
        self.callOption.callsSubscriptionKey = [NSString stringWithFormat:@"SYMBOLS/QUOTES/%@",[inDictionary[@"callOption"] objectForKey:@"subscriptionKey"]];
        self.putOption = [[TTPutOption alloc] init];
        self.putOption.putsSubscriptionKey = [NSString stringWithFormat:@"SYMBOLS/QUOTES/%@",[inDictionary[@"putOption"] objectForKey:@"subscriptionKey"]];
        self.strikePrice = EMPTY_IF_NIL(inDictionary[@"strikePrice"]);
        return self;
    }
    return nil;

}

@end
