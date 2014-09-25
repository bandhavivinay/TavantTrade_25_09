//
//  TTRecommendation.h
//  TavantTrade
//
//  Created by Bandhavi on 2/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMPTY_IF_NIL(__STRING) ((__STRING!=[NSNull null]) ? __STRING : @"")

@interface TTRecommendation : NSObject
@property(nonatomic,strong)NSString *symbolName;
@property(nonatomic,strong)NSString *companyName;
@property(nonatomic,strong)NSString *recommendationID;
@property(nonatomic,strong)NSString *source;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSMutableArray *targetArray;
-(id)initWithRecommendationDictionary:(NSDictionary *)inDictionary;
@end
