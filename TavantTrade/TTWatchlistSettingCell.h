//
//  TTWatchlistSettingCell.h
//  TavantTrade
//
//  Created by Bandhavi on 6/5/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TTWatchlistSettingsCellDelegate;

@interface TTWatchlistSettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *icon;

@property (nonatomic, assign) NSObject <TTWatchlistSettingsCellDelegate> *delegate;

@end


@protocol TTWatchlistSettingsCellDelegate <NSObject>

- (void) watchlistSettingsCellDidSelect:(TTWatchlistSettingCell *)inCell;

@end
