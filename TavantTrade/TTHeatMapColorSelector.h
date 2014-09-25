//
//  TTHeatMapColorSelector.h
//  TavantTrade
//
//  Created by Bandhavi on 5/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTHeatMapColorSelector : NSObject
+(UIColor *)returnColorForPercentageChange:(float)inPercentageChange;
+(UIColor *)returnColorForColorCase:(int)inColorCase;
+(NSString *)returnPercentageRangeForColorCase:(int)inColorCase;
@end
