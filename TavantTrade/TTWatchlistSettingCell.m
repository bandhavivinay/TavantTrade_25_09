//
//  TTWatchlistSettingCell.m
//  TavantTrade
//
//  Created by Bandhavi on 6/5/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTWatchlistSettingCell.h"

@implementation TTWatchlistSettingCell

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

-(IBAction)selectionAction:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(watchlistSettingsCellDidSelect:)])
    {
        [_delegate watchlistSettingsCellDidSelect:self];
    }
}


@end
