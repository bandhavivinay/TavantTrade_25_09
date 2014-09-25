//
//  TTDataSource.h
//  TavantTrade
//
//  Created by Bandhavi on 1/24/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTConstants.h"

@interface TTDataSource : NSObject
@property(nonatomic,assign)MarketDataType marketType;
@property(nonatomic,strong)NSString *imageFile;
@property(nonatomic,strong)NSMutableArray *currentCompanyArray;
@end
