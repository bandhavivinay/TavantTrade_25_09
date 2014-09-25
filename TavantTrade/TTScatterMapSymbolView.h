//
//  TTSymbolView.h
//  TavantTrade
//
//  Created by Bandhavi on 5/20/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMapData.h"

@class TTScatterMapSymbolView;

@protocol TTSymbolViewDelegate <NSObject>

-(void)didClickSymbolView:(TTScatterMapSymbolView *)inView;

@end

@interface TTScatterMapSymbolView : UIView
@property(nonatomic,weak)id<TTSymbolViewDelegate> symbolViewDelegate;
@property(nonatomic,strong)TTMapData *mapData;
@property(nonatomic,assign)BOOL isSelected;
@end
