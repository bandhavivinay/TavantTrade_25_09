//
//  TTCompanyData.m
//  TavantTrade
//
//  Created by Bandhavi on 1/20/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTCompanyData.h"

@implementation TTCompanyData

@synthesize closePrice,companyCode,companyName,highPrice,lowPrice,netChange,openPrice,percentageChange,previousClosePrice,scriptCode,symbolName,volume;

-(id)initWithDictionary:(id)dataDictionary{
    self = [super init];
    if(self){
        
        scriptCode = EMPTY_IF_NIL(dataDictionary[@"scripCode"]);
        companyCode = EMPTY_IF_NIL(dataDictionary[@"companyCode"]);
        symbolName = EMPTY_IF_NIL(dataDictionary[@"symbol"]);
        companyName = EMPTY_IF_NIL(dataDictionary[@"companyName"]);
        
        //TODO:Server Side ...
        
        if([[dataDictionary allKeys] containsObject:@"closePrice"])
            closePrice = EMPTY_IF_NIL(dataDictionary[@"closePrice"]);
        else
            closePrice = EMPTY_IF_NIL(dataDictionary[@"price"]);
        
        if([[dataDictionary allKeys] containsObject:@"previousClose"])
            previousClosePrice = [NSString stringWithFormat:@"%.02f",[dataDictionary[@"previousClose"]floatValue]];
        else
            previousClosePrice = [NSString stringWithFormat:@"%.02f",[dataDictionary[@"previousPrice"]floatValue]];
        
        if([[dataDictionary allKeys] containsObject:@"percentageChange"])
            percentageChange = [NSString stringWithFormat:@"%.02f%%",[dataDictionary[@"percentageChange"]floatValue]];
        else
            percentageChange = [NSString stringWithFormat:@"%.02f%%",[dataDictionary[@"pricePercentageChange"]floatValue]];
        
        
        netChange = EMPTY_IF_NIL(dataDictionary[@"netChange"]);
        NSLog(@"****** before crash %@",dataDictionary);
        
        openPrice = EMPTY_IF_NIL(dataDictionary[@"open"]);
        highPrice = EMPTY_IF_NIL(dataDictionary[@"high"]);
        lowPrice = EMPTY_IF_NIL(dataDictionary[@"low"]);
        volume = [NSString stringWithFormat:@"%.02f M",[dataDictionary[@"volume"]floatValue]/10000.00];

        return self;
    }
                                 
    return nil;
}


@end
