//
//  TTSymbolSearchTableCell.m
//  TavantTrade
//
//  Created by Bandhavi on 12/12/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTSymbolSearchTableCell.h"
#import "SBITradingUtility.h"
#import "TTAlertView.h"

@implementation TTSymbolSearchTableCell

@synthesize companyNameLabel,symbolNameLabel,selectSymbolButton,expiryDateButton,optionButton,strikePriceButton;

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

-(IBAction)selectTheSymbol:(id)sender{

    [selectSymbolButton setBackgroundImage:[UIImage imageNamed:@"redio_button_select.png"] forState:UIControlStateNormal];
//    [selectSymbolButton setSelected:YES];
    [self.selectSymbolDelegate selectSearchSymbol:self.symbolCellData.symbolData ForCell:self];
}

-(IBAction)setExpiryDate:(id)sender{
    [self.selectSymbolDelegate displayExpiryDatePopOver:self];
}

-(IBAction)setOptionType:(id)sender{
    [self.selectSymbolDelegate displayOptionTypePopOver:self];
}

-(IBAction)setStrikePrice:(id)sender{
    
    if([expiryDateButton.titleLabel.text isEqualToString:@"Expiry Date"] || [optionButton.titleLabel.text isEqualToString:@"Option Type"]){
        //prompt the user saying that strike price can't be selected...
        TTAlertView *alertView = [TTAlertView sharedAlert];
        [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"ExpiryDate_OptionType_Alert", @"Localizable",@"Please select both Expiry Date and Option Type")];
    }
    else{
        [self.selectSymbolDelegate displayStrikePricePopOver:self];
    }
    
}

-(void)paintUI{

    [self setExpiryDateButtonTitle:self.symbolCellData.expiryDate];
    [self setOptionTypeButtonTitle:self.symbolCellData.optionType];
    [self setStrikePriceButtonTitle:self.symbolCellData.strikePrice];
    
    NSLog(@"self.symbolCellData is %@ and isSelected is %hhd",self.symbolCellData,self.symbolCellData.isSelected);
    
    if(self.symbolCellData.isSelected){
        [selectSymbolButton setBackgroundImage:[UIImage imageNamed:@"redio_button_select.png"] forState:UIControlStateNormal];
    }
    else{
        [selectSymbolButton setBackgroundImage:[UIImage imageNamed:@"redio_button_unselect.png"] forState:UIControlStateNormal];
    }
    
    self.companyNameLabel.text = self.symbolCellData.symbolData.symbolData.companyName;
    self.symbolNameLabel.text = self.symbolCellData.symbolData.symbolData.tradeSymbolName;
}

-(void)setExpiryDateButtonTitle:(NSString *)title{
    if([title length] != 0)
        [self.expiryDateButton setTitle:title forState:UIControlStateNormal];
    else
        [self.expiryDateButton setTitle:@"Expiry Date" forState:UIControlStateNormal];
}

-(void)setOptionTypeButtonTitle:(NSString *)title{
    if([title length] != 0)
        [self.optionButton setTitle:title forState:UIControlStateNormal];
    else
        [self.optionButton setTitle:@"Option Type" forState:UIControlStateNormal];
}

-(void)setStrikePriceButtonTitle:(NSString *)title{
    if([title length] != 0)
        [self.strikePriceButton setTitle:title forState:UIControlStateNormal];
    else
        [self.strikePriceButton setTitle:@"Strike Price" forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    symbolNameLabel.font = companyNameLabel.font = expiryDateButton.titleLabel.font = optionButton.titleLabel.font = strikePriceButton.titleLabel.font = REGULAR_FONT_SIZE(13.0);
}

@end
