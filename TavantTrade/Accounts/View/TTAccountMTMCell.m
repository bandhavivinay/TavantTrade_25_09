//
//  TTAccountMTMCell.m
//  TavantTrade
//
//  Created by TAVANT on 2/11/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTAccountMTMCell.h"
#import "TTConstants.h"

@implementation TTAccountMTMCell

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

//-(void)layoutSubviews{
//    _marginUsed.font = _marginUsedTitle.font = _realizedmtmGain.font = _realizedmtmGainTitle.font = _cncSalesProceeds.font = _cncSalesProceedsTitle.font = _unrealizedmtmLoss.font = _unrealizedmtmLossTitle.font = REGULAR_FONT_SIZE(13.0);
//    _marginUsedForOrders.font = _valueLabel.font = REGULAR_FONT_SIZE(15.0);
//}

@end
