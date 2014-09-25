//
//  TTSymbolDetails.m
//  TavantTrade
//
//  Created by Bandhavi on 1/16/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTSymbolDetails.h"
#import "DFTopicMessage.h"
#import "SBITradingUtility.h"
#import "TTDiffusionData.h"


static TTSymbolDetails *sharedSymbolManager = nil;

@implementation TTSymbolDetails

+ (id)sharedSymbolDetailsManager
{
    if(!sharedSymbolManager)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedSymbolManager = [[super allocWithZone:nil] init];
        });
    }
    
    return sharedSymbolManager;
}

//-(void)subscribeTheSymbol{
//    TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
//    [diffusionHandler subscribe:self.symbolData.symbolData.symbolName withContext:self];
//}

//#pragma Diffusion Delegates
//
//-(void)onDelta:(DFTopicMessage *)message{
//    
//    //find the row to be updated...
//    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
//    self.diffusionData = [[TTDiffusionData alloc] init];
//    self.diffusionData = [self.diffusionData updateDiffusionDataWith:parsedArray];
//
//}

@end
