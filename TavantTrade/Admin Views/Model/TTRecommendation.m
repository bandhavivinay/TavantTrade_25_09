//
//  TTRecommendation.m
//  TavantTrade
//
//  Created by Bandhavi on 2/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTRecommendation.h"

@implementation TTRecommendation

-(id)initWithRecommendationDictionary:(NSDictionary *)inDictionary{
    self = [super init];
    if(self){
        
        self.symbolName = EMPTY_IF_NIL(inDictionary[@"symbol"]);
        self.companyName = EMPTY_IF_NIL(inDictionary[@"companyName"]);
        self.recommendationID = EMPTY_IF_NIL(inDictionary[@"id"]);
        self.source = EMPTY_IF_NIL(inDictionary[@"source"]);
        self.type = EMPTY_IF_NIL(inDictionary[@"directionalView"]);
        //form the target array ...
        
        self.targetArray = [[NSMutableArray alloc] init];
        
        NSString *target1 = EMPTY_IF_NIL(inDictionary[@"target1"]);
        NSString *target2 = EMPTY_IF_NIL(inDictionary[@"target2"]);
        NSString *target3 = EMPTY_IF_NIL(inDictionary[@"target3"]);
        
//        if([target1 length] > 0)
            [self.targetArray addObject:target1];
//        if([target2 length] > 0)
            [self.targetArray addObject:target2];
//        if([target3 length] > 0)
            [self.targetArray addObject:target3];
        
        return self;
    }
    return nil;
    
}


@end
