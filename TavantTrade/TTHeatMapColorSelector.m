//
//  TTHeatMapColorSelector.m
//  TavantTrade
//
//  Created by Bandhavi on 5/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTHeatMapColorSelector.h"

@implementation TTHeatMapColorSelector

+(NSString *)returnPercentageRangeForColorCase:(int)inColorCase{
    switch (inColorCase) {
        case 4:
            return @"0%";
            break;
        case 1:
            return @"-3.0% or less";
            break;
        case 2:
            return @"-2.0% to -2.99%";
            break;
        case 3:
            return @"-0.01% to -1.99%";
            break;
        case 7:
            return @"+3.0% or more";
            break;
        case 6:
            return @"+2.0% to 2.99%";
            break;
        case 5:
            return @"+0.01% to 1.99%";
            break;
        default:
            return @"";
            break;
    }
}

+(UIColor *)returnColorForColorCase:(int)inColorCase{
    switch (inColorCase) {
        case 4:
            return [UIColor colorWithRed:153/255.0 green:153/255.0  blue:153/255.0 alpha:1.0];
            break;
        case 1:
            return [UIColor colorWithRed:211/255.0 green:17/255.0  blue:21/255.0 alpha:1.0];
            break;
        case 2:
            return [UIColor colorWithRed:213/255.0 green:30/255.0  blue:40/255.0 alpha:1.0];
            break;
        case 3:
            return [UIColor colorWithRed:231/255.0 green:80/255.0  blue:84/255.0 alpha:1.0];
            break;
        case 7:
            return [UIColor colorWithRed:46/255.0 green:99/255.0  blue:6/255.0 alpha:1.0];
            break;
        case 6:
            return [UIColor colorWithRed:74/255.0 green:162/255.0  blue:8/255.0 alpha:1.0];
            break;
        case 5:
            return [UIColor colorWithRed:137/255.0 green:202/255.0  blue:79/255.0 alpha:1.0];
            break;
        default:
            return [UIColor blackColor];
            break;
    }
}

+(UIColor *)returnColorForPercentageChange:(float)inPercentageChange{
    if(inPercentageChange == 0)
        return [self returnColorForColorCase:4];
    //    else if(inPercentageChange <= -4)
    //        return [UIColor colorWithRed:121/255.0 green:10/255.0  blue:0/255.0 alpha:1.0];
    else if (inPercentageChange <= -3)
        return [self returnColorForColorCase:1];
    else if (inPercentageChange < -2)
        return [self returnColorForColorCase:2];
    //    else if (inPercentageChange < -1)
    //        return [UIColor colorWithRed:174/255.0 green:42/255.0  blue:36/255.0 alpha:1.0];
    else if (inPercentageChange < 0)
        return [self returnColorForColorCase:3];
    //    else if (inPercentageChange >= 4)
    //        return [UIColor colorWithRed:31/255.0 green:85/255.0  blue:0/255.0 alpha:1.0];
    else if (inPercentageChange >= 3)
        return [self returnColorForColorCase:7];
    else if (inPercentageChange > 2)
        return [self returnColorForColorCase:6];
    else if (inPercentageChange > 0)
        return [self returnColorForColorCase:5];
    else
        return [self returnColorForColorCase:8];
}

@end
