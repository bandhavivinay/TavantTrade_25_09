//
//  TTCellData.m
//  TavantTrade
//
//  Created by Bandhavi on 2/4/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTCellData.h"

@implementation TTCellData
@synthesize expiryDate,isSelected,optionType,strikePrice,symbolData;
-(id)init{
    self = [super init];
    if(self){
        symbolData = [[TTSymbolSearch alloc] init];
        return self;
    }
    return nil;
}
@end
