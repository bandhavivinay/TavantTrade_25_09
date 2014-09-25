//
//  TTOrderTableViewCell.m
//  TavantTrade
//
//  Created by Bandhavi on 2/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTOrderTableViewCell.h"
#import "TTConstants.h"

@implementation TTOrderTableViewCell

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
    _statusLabel.font = _orderTypeLabel.font = _orderPriceLabel.font =_symbolNameLabel.font = _statusHeadingLabel.font = _typeHeadingLabel.font = _priceHeadingLabel.font =_symbolHeadingLabel.font = REGULAR_FONT_SIZE(13.0);
    
}

@end
