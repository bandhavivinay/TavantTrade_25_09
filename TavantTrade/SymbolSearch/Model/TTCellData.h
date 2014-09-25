//
//  TTCellData.h
//  TavantTrade
//
//  Created by Bandhavi on 2/4/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTSymbolSearch.h"

@interface TTCellData : NSObject
@property(nonatomic,strong)TTSymbolSearch *symbolData;
@property(nonatomic,strong)NSString *expiryDate;
@property(nonatomic,strong)NSString *strikePrice;
@property(nonatomic,strong)NSString *optionType;
@property(nonatomic,assign)BOOL isSelected;
@end
