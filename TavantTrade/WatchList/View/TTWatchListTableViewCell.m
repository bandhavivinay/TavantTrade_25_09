//
//  TTWatchListTableViewCell.m
//  TavantTrade
//
//  Created by Bandhavi on 12/13/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTWatchListTableViewCell.h"
#import "TTConstants.h"

@implementation TTWatchListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)editWatchlist:(id)sender{
    [self.selectWatchlistDelegate editWatchlist:self.watchListData];
}

-(void)layoutSubviews{
    _watchListNameLabel.font = REGULAR_FONT_SIZE(17.0);
}

@end
