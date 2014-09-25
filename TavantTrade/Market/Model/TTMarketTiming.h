//
//  TTMarketTiming.h
//  TavantTrade
//
//  Created by TAVANT on 2/10/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//
#define EMPTY_IF_NIL(__STRING) (__STRING ? __STRING : @"")

#import <UIKit/UIKit.h>

@interface TTMarketTiming : UIView
@property(nonatomic,retain) NSString * subKey;
@property(nonatomic,retain) NSString *marketStatus;
@property(nonatomic,strong) NSString *topic;
-(id)updateMarketTiming:(NSArray *)streamingData;
@end
