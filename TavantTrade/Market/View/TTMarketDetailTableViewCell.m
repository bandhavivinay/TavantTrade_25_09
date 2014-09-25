//
//  TTMarketDetailTableViewCell.m
//  TavantTrade
//
//  Created by Bandhavi on 1/24/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTMarketDetailTableViewCell.h"
#import "TTConstants.h"

@implementation TTMarketDetailTableViewCell

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

-(void)layoutSubviews{
    _changeLabel.font = _ltpLabel.font = SEMI_BOLD_FONT_SIZE(14.0);
    _companyNameLabel.font = REGULAR_FONT_SIZE(16.0);
}

@end
