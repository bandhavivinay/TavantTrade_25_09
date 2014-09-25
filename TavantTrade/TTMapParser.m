//
//  TTMapParser.m
//  TavantTrade
//
//  Created by Bandhavi on 5/21/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTMapParser.h"
#import "GDataXMLNode.h"
#import "TTMapData.h"
#import "TTConstants.h"

@implementation TTMapParser

+(NSMutableArray *)returnScatterMapDataArray:(NSData *)xmlData andPopulateArray:(NSMutableArray *)inArray{
    NSError *error;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    GDataXMLElement * rootElement = (GDataXMLElement *)[[doc.rootElement elementsForName:@"HeatMapResult"] objectAtIndex:0];
    NSLog(@"%@",rootElement);
    
    NSArray *symbolsArray = [rootElement elementsForName:@"HeatMapInfo"];
    
    for(GDataXMLElement *mapDataElement in symbolsArray){
        TTMapData *mapData = [[TTMapData alloc] init];
        GDataXMLElement * exchangeTypeElement = [[mapDataElement elementsForName:@"stk_exchng"] objectAtIndex:0];
        if([[exchangeTypeElement stringValue] isEqualToString:@"NSE"])
            mapData.exchangeType = eNSE;
        else
            mapData.exchangeType = eBSE;
        GDataXMLElement * symbolNameElement = [[mapDataElement elementsForName:@"symbol"] objectAtIndex:0];
        mapData.symbolName = [symbolNameElement stringValue];
        
        GDataXMLElement * companyNameElement = [[mapDataElement elementsForName:@"co_name"] objectAtIndex:0];
        mapData.companyName = [companyNameElement stringValue];
        
        GDataXMLElement * percentageChangeElement = [[mapDataElement elementsForName:@"perchg"] objectAtIndex:0];
        mapData.percentageChange = [percentageChangeElement stringValue];
        
        GDataXMLElement * turnOverElement = [[mapDataElement elementsForName:@"Turnover"] objectAtIndex:0];
        mapData.turnover = [turnOverElement stringValue];
        
        GDataXMLElement * OIChangeElement = [[mapDataElement elementsForName:@"OIChange"] objectAtIndex:0];
        mapData.OIChange = [OIChangeElement stringValue];
        
        GDataXMLElement * netChangeElement = [[mapDataElement elementsForName:@"netchg"] objectAtIndex:0];
        mapData.netChange = [netChangeElement stringValue];
        
        GDataXMLElement * volElement = [[mapDataElement elementsForName:@"vol_traded"] objectAtIndex:0];
        mapData.volume = [volElement stringValue];
        
        [inArray addObject:mapData];
        
    }
    
    NSLog(@"Array is %@",inArray);
    
    return inArray;
}

//-(NSString *)returnValueFor:(NSString *)inValue fromXMLData:(NSData *)xmlData{
//    NSError *error;
//    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
//    GDataXMLElement * rootElement = (GDataXMLElement *)[[doc.rootElement elementsForName:@"ClientStatusResult"] objectAtIndex:0];
//    NSLog(@"%@",rootElement);
//
//}

@end
