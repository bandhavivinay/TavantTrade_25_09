//
//  TTMenuTableViewCell.m
//  TavantTrade
//
//  Created by Bandhavi on 12/20/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTMenuTableViewCell.h"

@implementation TTMenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       _labelView.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17.0f];
       _labelView.textColor = [UIColor whiteColor];

    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _labelView.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17.0f];
        _labelView.textColor = [UIColor whiteColor];
        
    }
    return self;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIconView:(UIImageView *)iconView
{
    _iconView = iconView;
}

@end
