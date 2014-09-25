//
//  TTWatchListTableViewCell.h
//  TavantTrade
//
//  Created by Bandhavi on 12/13/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTWatchlist.h"

@protocol SelectWatchlistProtocol
-(void)editWatchlist:(TTWatchlist *)watchlist;
@end

@interface TTWatchListTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *watchListNameLabel;
@property(nonatomic,weak)IBOutlet UIButton *watchlistInfoButton;
@property(nonatomic,strong)TTWatchlist *watchListData;
@property(nonatomic,assign)id<SelectWatchlistProtocol> selectWatchlistDelegate;
-(IBAction)editWatchlist:(id)sender;
@end

