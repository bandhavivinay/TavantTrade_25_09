//
//  TTNewsData.h
//  TavantTrade
//
//  Created by Bandhavi on 1/31/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMPTY_IF_NIL(__STRING) (__STRING ? __STRING : @"")

@interface TTNewsData : NSObject

@property(nonatomic,strong)NSString *serialNumber;
@property(nonatomic,strong)NSString *sectionName;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *heading;
@property(nonatomic,strong)NSString *description;

-(id)initWithDictionary:(id)newsDataDictionary;

@end
