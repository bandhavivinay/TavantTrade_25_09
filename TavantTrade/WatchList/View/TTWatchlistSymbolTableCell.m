//
//  TTWatchlistSymbolTableCell.m
//  TavantTrade
//
//  Created by Bandhavi on 12/11/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTWatchlistSymbolTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SBITradingUtility.h"

#define COLUMN_WIDTH 100

@interface TTWatchlistSymbolTableCell()
@property (weak, nonatomic) IBOutlet UILabel *ltpTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *askTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayRangeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiftyTwoWeekTitleLabel;

@end

@implementation TTWatchlistSymbolTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        _watchlistColumnsArray = [];
        
    }
    return self;
}

-(void)layoutSubviews{
    
    _ltpTitleLabel.text = NSLocalizedStringFromTable(@"Last_Trade", @"Localizable", @"Last Trade");
    _changeTitleLabel.text = NSLocalizedStringFromTable(@"Change", @"Localizable", @"Change");
    _bidTitleLabel.text = NSLocalizedStringFromTable(@"Bid", @"Localizable", @"Bid");
    _askTitleLabel.text = NSLocalizedStringFromTable(@"Ask", @"Localizable", @"Ask");
    _volumeTitleLabel.text = NSLocalizedStringFromTable(@"Volume", @"Localizable", @"Volume");
    _dayRangeTitleLabel.text = NSLocalizedStringFromTable(@"Day_Range", @"Localizable", @"Day Range");
    _fiftyTwoWeekTitleLabel.text = NSLocalizedStringFromTable(@"FiftyTwoWeek_Range", @"Localizable", @"52 Week Range");
    
    self.symbolName.layer.cornerRadius = 3.0f;
    _volumeLabel.font = _lastTradeLabel.font = _changeLabel.font = _bidLabel.font = _askLabel.font = _dayRangeLabel.font = _fiftyTwoWeekRangeLabel.font = _closeLabel.font = SEMI_BOLD_FONT_SIZE(12.0);
    
    _ltpTitleLabel.font = _changeTitleLabel.font = _bidTitleLabel.font = _askTitleLabel.font = _dayRangeTitleLabel.font = _fiftyTwoWeekTitleLabel.font = _volumeTitleLabel.font = SEMI_BOLD_FONT_SIZE(10.0);
    
    _symbolName.titleLabel.font = _companyNameLabel.font = SEMI_BOLD_FONT_SIZE(13.0);
        
    float xPos = TABLE_WIDTH - COLUMN_OFFSET;
    // add the columns as per the watchlist setting ...
    for(NSDictionary *columnObject in _watchlistColumnsArray){
        xPos+=COLUMN_OFFSET;
        float columnWidth = 100.0;//[SBITradingUtility getWatchlistColumnWidthFor:[[columnObject valueForKey:@"Type"] floatValue]];
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos + COLUMN_OFFSET, 23.0 , columnWidth, 21)];
        valueLabel.font = SEMI_BOLD_FONT_SIZE(12.0);
        valueLabel.text = @"0";
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos + COLUMN_OFFSET, 42.0 , columnWidth, 21)];
        titleLabel.font = SEMI_BOLD_FONT_SIZE(10.0);
        titleLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        titleLabel.text = [columnObject valueForKey:@"Name"];
        
        EWatchlistColumns column = (EWatchlistColumns)[[columnObject valueForKey:@"Type"] intValue];
        NSString *diffusionKey = [SBITradingUtility  getWatchlistKey:column];
        NSLog(@"Key is %@ and column is %d",diffusionKey,column);
        if([diffusionKey length] > 0){
            NSString *value = [_difusionData valueForKeyPath:diffusionKey];
            if([value length]!=0)
                valueLabel.text = value;
        }
        xPos = xPos+columnWidth;
        [self addSubview:valueLabel];
        [self addSubview:titleLabel];
        
    }
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)openTradeScreen:(id)sender{
    [self.watchListCellDelegate didSelectTradeButton:self];
}

@end
