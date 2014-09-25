//
//  TTMapData.m
//  TavantTrade
//
//  Created by Bandhavi on 5/21/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTMapData.h"

@implementation TTMapData

//-(id)init{
//    self = [super init];
//    if(self){
//        return self;
//    }
//    return nil;
//}

-(id)initWithDictionary:(id)mapDictionary{
    self = [super init];
    if(self){
        if([mapDictionary[@"stockExchange"] isEqualToString:@"NSE"])
            self.exchangeType = eNSE;
        else
            self.exchangeType = eBSE;
        self.symbolName = mapDictionary[@"symbol"];
        
        self.companyName = mapDictionary[@"companyName"];
        
        self.percentageChange = mapDictionary[@"percentageChange"];
        
        self.turnover = mapDictionary[@"turnOver"];
        
        self.OIChange = mapDictionary[@"oiChange"];
        
        self.netChange = EMPTY_IF_NIL(mapDictionary[@"netChange"]);
        
        self.volume = mapDictionary[@"volumeTraded"];

        
        return self;
    }
    return nil;
}


//-(void)updateMapDataWith:(NSMutableDictionary *)inDictionary{
//    
//}

@end
