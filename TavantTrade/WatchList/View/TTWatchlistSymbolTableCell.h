//
//  TTWatchlistSymbolTableCell.h
//  TavantTrade
//
//  Created by Bandhavi on 12/11/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDiffusionData.h"

@class TTWatchlistSymbolTableCell;
@protocol TTWatchlistCellDelegate
-(void)didSelectTradeButton:(TTWatchlistSymbolTableCell *)inCell;
@end

@interface TTWatchlistSymbolTableCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *companyNameLabel;
@property(nonatomic,weak)IBOutlet UIButton *symbolName;
@property(nonatomic,weak)IBOutlet UILabel *volumeLabel;
@property(nonatomic,weak)IBOutlet UILabel *lastTradeLabel;
@property(nonatomic,weak)IBOutlet UILabel *changeLabel;
@property(nonatomic,weak)IBOutlet UILabel *bidLabel;
@property(nonatomic,weak)IBOutlet UILabel *askLabel;
@property(nonatomic,weak)IBOutlet UILabel *dayRangeLabel;
@property(nonatomic,weak)IBOutlet UILabel *closeLabel;
@property(nonatomic,weak)IBOutlet UILabel *fiftyTwoWeekRangeLabel;
@property(nonatomic,assign)id<TTWatchlistCellDelegate> watchListCellDelegate;
@property(nonatomic,strong)TTDiffusionData *difusionData;
@property(nonatomic,strong)NSMutableArray *watchlistColumnsArray;
@end
