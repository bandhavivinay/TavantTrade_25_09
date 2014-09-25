//
//  TTCallOption.m
//  TavantTrade
//
//  Created by Bandhavi on 3/10/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTCallOption.h"

@implementation TTCallOption

-(id)init{
    self = [super init];
    if(self){

        return self;
    }
    return nil;
    
}

-(id)updateWithCallsDictionary:(NSArray *)streamingData{
    self.callsAskValue = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:12] floatValue]);
    self.callsBidValue = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:10] floatValue]);
    
    self.callsLTP = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:13] floatValue]);
    self.callsVolume = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:16] floatValue]);
    self.callsOI = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:23] floatValue]);
    
    
    return self;
}


@end
