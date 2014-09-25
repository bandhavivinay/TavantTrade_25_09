//
//  TTSymbolDetails.h
//  TavantTrade
//
//  Created by Bandhavi on 1/16/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTDiffusionHandler.h"
#import "TTSymbolData.h"


@interface TTSymbolDetails : NSObject
@property(nonatomic,strong)TTSymbolData *symbolData;
+ (id)sharedSymbolDetailsManager;
//-(void)subscribeTheSymbol;
//-(id)getDetails;
@end
