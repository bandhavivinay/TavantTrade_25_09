//
//  TTHeatMapSymbolView.h
//  TavantTrade
//
//  Created by Bandhavi on 5/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMapData.h"

@class TTHeatMapSymbolView;

@protocol TTHeatMapSymbolViewDelegate <NSObject>

-(void)didClickHeatSymbolView:(TTHeatMapSymbolView *)inView;

@end


@interface TTHeatMapSymbolView : UIView
@property(nonatomic,weak)id<TTHeatMapSymbolViewDelegate> heatSymbolViewDelegate;
@property(nonatomic,strong)TTMapData *currentMapData;
@property(nonatomic,assign)BOOL isSelected;
@end
