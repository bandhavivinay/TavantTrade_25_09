//
//  normalCell.m
//  TavantTrade
//
//  Created by TAVANT on 2/6/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTAccountNormalCell.h"
#import "TTConstants.h"

@implementation TTAccountNormalCell

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
//    _valueInRupee.font = _valueLabel.font = REGULAR_FONT_SIZE(15.0);
//}

@end
