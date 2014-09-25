//
//  TTRecommendationTableViewCell.m
//  TavantTrade
//
//  Created by Bandhavi on 2/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTRecommendationTableViewCell.h"
#import "TTConstants.h"

@interface TTRecommendationTableViewCell()
@property(nonatomic,weak)IBOutlet UILabel *symbolNameLabel;
@property(nonatomic,weak)IBOutlet UILabel *companyNameLabel;
@property(nonatomic,weak)IBOutlet UILabel *sourceHeadingLabel;
@property(nonatomic,weak)IBOutlet UILabel *targetHeadingLabel;
@property(nonatomic,weak)IBOutlet UILabel *sourceValueLabel;
@property(nonatomic,weak)IBOutlet UILabel *target1Label;
@property(nonatomic,weak)IBOutlet UILabel *target2Label;
@property(nonatomic,weak)IBOutlet UILabel *target3Label;
@end

@implementation TTRecommendationTableViewCell

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

-(void)configureCellWithObject:(TTRecommendation *)inObject{
    self.symbolNameLabel.text = inObject.symbolName;
    self.companyNameLabel.text = inObject.companyName;
    self.sourceValueLabel.text = inObject.source;
    NSLog(@"1 %@ 2 %@ 3 %@",[inObject.targetArray objectAtIndex:0],[inObject.targetArray objectAtIndex:1],[inObject.targetArray objectAtIndex:2]);
    self.target1Label.text = [NSString stringWithFormat:@"%.2f",[[inObject.targetArray objectAtIndex:0] doubleValue]];
    self.target2Label.text = [NSString stringWithFormat:@"%.2f",[[inObject.targetArray objectAtIndex:1] doubleValue]];
    self.target3Label.text = [NSString stringWithFormat:@"%.2f",[[inObject.targetArray objectAtIndex:2] doubleValue]];
}

-(void)setFontForEnlargedView{
    self.symbolNameLabel.font = SEMI_BOLD_FONT_SIZE(16.0);
    self.companyNameLabel.font = REGULAR_FONT_SIZE(14.0);
    self.sourceHeadingLabel.font = self.sourceValueLabel.font = self.targetHeadingLabel.font = self.target1Label.font = self.target2Label.font = self.target3Label.font = REGULAR_FONT_SIZE(14.0);
}

-(void)setFontForWidgetView{
    self.symbolNameLabel.font = SEMI_BOLD_FONT_SIZE(14.0);
    self.companyNameLabel.font = REGULAR_FONT_SIZE(11.0);
    self.sourceHeadingLabel.font = self.sourceValueLabel.font = self.targetHeadingLabel.font = self.target1Label.font = self.target2Label.font = self.target3Label.font = REGULAR_FONT_SIZE(11.0);
}

@end
