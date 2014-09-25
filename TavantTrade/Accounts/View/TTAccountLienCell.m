//
//  TTAccountLienCell.m
//  TavantTrade
//
//  Created by TAVANT on 2/10/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTAccountLienCell.h"
#import "TTConstants.h"

@implementation TTAccountLienCell

@synthesize delegate;

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
-(IBAction)showfundLien:(id)sender{
    
      NSString *url = @"http://www.google.com";
    [delegate openWebViewFromUrl:url];
}
                    
-(IBAction)showdpLien:(id)sender{
    NSString *url = @"http://www.google.com";
    [delegate openWebViewFromUrl:url];
}

//-(void)layoutSubviews{
//    _valueLabel.font = _valueInRupee.font = _fundLienButton.titleLabel.font = _dpLienButton.titleLabel.font = REGULAR_FONT_SIZE(15.0);
//}


@end
