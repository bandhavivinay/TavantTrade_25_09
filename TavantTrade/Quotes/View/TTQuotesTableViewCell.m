//
//  TTQuotesTableViewCell.m
//  TavantTrade
//
//  Created by Bandhavi on 1/22/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTQuotesTableViewCell.h"
#import "SBITradingUtility.h"

@implementation TTQuotesTableViewCell

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
//    _leftTitleLabel.font = [UIFont fontWithName:@"Avenir Roman" size:15.0f];
//}

@end
