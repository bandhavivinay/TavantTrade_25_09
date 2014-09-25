//
//  TTNewsData.m
//  TavantTrade
//
//  Created by Bandhavi on 1/31/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTNewsData.h"

@implementation TTNewsData
@synthesize serialNumber,sectionName,date,time,heading,description;

-(id)initWithDictionary:(id)newsDataDictionary{
    self = [super init];
    if(self){
        self.serialNumber = EMPTY_IF_NIL(newsDataDictionary[@"serialNumber"]) ;
        self.sectionName = EMPTY_IF_NIL(newsDataDictionary[@"sectionName"]);
        self.date = EMPTY_IF_NIL(newsDataDictionary[@"date"]);
        self.time = EMPTY_IF_NIL(newsDataDictionary[@"time"]);
        self.heading = EMPTY_IF_NIL(newsDataDictionary[@"heading"]);
        if([newsDataDictionary[@"arttext"] class] != [NSNull class]){
            self.description = EMPTY_IF_NIL(newsDataDictionary[@"arttext"]);
            self.description = [self.description stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
            self.description = [self.description stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
            self.description = [self.description stringByReplacingOccurrencesOfString:@"<i>" withString:@""];
            self.description = [self.description stringByReplacingOccurrencesOfString:@"</i>" withString:@""];
            self.description = [self.description stringByReplacingOccurrencesOfString:@"<P>" withString:@""];
        }
        else
            self.description = @"";
        
        return self;
    }
    return nil;
}

@end
