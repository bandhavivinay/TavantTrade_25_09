//
//  TTAccountMarginCell.m
//  TavantTrade
//
//  Created by TAVANT on 2/10/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTAccountMarginCell.h"
#import "TTConstants.h"

@implementation TTAccountMarginCell

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
//    _adhocMargin.font = _adhocMarginTitle.font = _nationalCash.font = _nationalCashTitle.font = _directCollatral.font = _directCollatralTitle.font = REGULAR_FONT_SIZE(13.0);
//    _valueLabel.font = _additinalAdhocMargin.font = REGULAR_FONT_SIZE(15.0);
//}

@end
