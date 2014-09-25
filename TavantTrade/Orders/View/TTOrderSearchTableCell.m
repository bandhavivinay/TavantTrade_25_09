//
//  TTOrderSearchTableCell.m
//  TavantTrade
//
//  Created by Bandhavi on 17/06/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTOrderSearchTableCell.h"

@implementation TTOrderSearchTableCell

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

-(IBAction)searchButtonSelected:(id)sender{
    [_selectionButton setBackgroundImage:[UIImage imageNamed:@"redio_button_select.png"] forState:UIControlStateNormal];
    [self.orderSearchDelegate didSelectOrderSearchParameter:self];
}

-(void)setIsSelected:(BOOL)isSelected{
    if(isSelected){
        [_selectionButton setBackgroundImage:[UIImage imageNamed:@"redio_button_select.png"] forState:UIControlStateNormal];
    }
    else{
        [_selectionButton setBackgroundImage:[UIImage imageNamed:@"redio_button_unselect.png"] forState:UIControlStateNormal];
    }
}

@end
