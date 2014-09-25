//
//  TTPutOption.m
//  TavantTrade
//
//  Created by Bandhavi on 3/10/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTPutOption.h"

@implementation TTPutOption

-(id)init{
    self = [super init];
    if(self){
        return self;
    }
    return nil;
}


-(id)updateWithPutsDictionary:(NSArray *)streamingData{
    self.putsAskValue = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:12] floatValue]);
    self.putsBidValue = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:10] floatValue]);

    self.putsLTP = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:13] floatValue]);
    self.putsVolume = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:16] floatValue]);
    self.putsOI = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:23] floatValue]);

    
    return self;
}


@end
