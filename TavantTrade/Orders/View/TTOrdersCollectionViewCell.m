//
//  TTOrdersCollectionViewCell.m
//  TavantTrade
//
//  Created by Bandhavi on 2/17/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTOrdersCollectionViewCell.h"
#import "TTConstants.h"
#import "SBITradingUtility.h"

@implementation TTOrdersCollectionViewCell

@synthesize dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //populate the title labels from the localizable string...
        _exchangeTitleLabel.text = NSLocalizedStringFromTable(@"Exchange_Title", @"Localizable", @"Exchange");
        _orderDurationLabel.text = NSLocalizedStringFromTable(@"Order_Duration", @"Localizable", @"Order Duration");
        _orderPriceTitleLabel.text = NSLocalizedStringFromTable(@"Order_Price", @"Localizable", @"Order Price");
        _disclosedQtyTitleLabel.text = NSLocalizedStringFromTable(@"Disclosed_Qty", @"Localizable", @"Disclosed Qty");
        _productTypeTitleLabel.text = NSLocalizedStringFromTable(@"Product_Type", @"Localizable", @"Product Type");
        _priceTitleLabel.text = NSLocalizedStringFromTable(@"Price_Type", @"Localizable", @"Price Type");
        _confirmTimeTitleLabel.text = NSLocalizedStringFromTable(@"Confirm_Time", @"Localizable", @"Confirm Time");
        _statusTitleLabel.text = NSLocalizedStringFromTable(@"Status_Title", @"Localizable", @"Status");
        _typeTitleLabel.text = NSLocalizedStringFromTable(@"Type_Title", @"Localizable", @"Type");
        _qtyTitleLabel.text = NSLocalizedStringFromTable(@"Qty_Title", @"Localizable", @"Qty");
        
        [self configureCell];
    }
    return self;
}

-(void)configureCell{
    
    self.symbolNameLabel.text = dataSource.symbolData.tradeSymbolName;
    
    self.exchangeTypeLabel.text = dataSource.exchangeType;
    self.disclosedQuantityLabel.text = [NSString stringWithFormat:@"%d",dataSource.disclosedQuantity];
    self.orderDurationLabel.text = dataSource.orderDuration;
    self.orderPriceLabel.text = [NSString stringWithFormat:@"%.2f",dataSource.priceToFill];
    self.productTypeLabel.text = dataSource.productType;
    self.priceTypeLabel.text = dataSource.priceType;
    self.confirmTimeLabel.text = [SBITradingUtility returnStringFromDate:dataSource.confirmDate];
    self.statusLabel.text = dataSource.status;
    
    if([self.statusLabel.text caseInsensitiveCompare:@"Rejected"] == NSOrderedSame)
        self.statusLabel.textColor = [UIColor redColor];
    else if([self.statusLabel.text isEqualToString:@"Open"])
        self.statusLabel.textColor = [UIColor orangeColor];
    else
        self.statusLabel.textColor = [UIColor colorWithRed:68.0/255.0 green:192.0/255.0 blue:81.0/255.0 alpha:1];
    
    self.typeLabel.text = dataSource.transactionType;
    self.quantityLabel.text = [NSString stringWithFormat:@"%d",dataSource.quantitytoFill];
    
    if([dataSource.rejectionReason length] > 0){
        self.comment.text = [@"Rejection Reason " stringByAppendingString:dataSource.rejectionReason];
    }
    else
        self.comment.text = @"";
    
}

-(void)layoutSubviews{
    self.exchangeTypeLabel.font = self.disclosedQuantityLabel.font = self.orderDurationLabel.font = self.orderPriceLabel.font = self.productTypeTitleLabel.font = self.priceTypeLabel.font = self.confirmTimeLabel.font = self.typeLabel.font = self.quantityLabel.font = self.comment.font = self.exchangeTitleLabel.font = _orderDurationLabel.font = self.orderPriceTitleLabel.font = self.disclosedQtyTitleLabel.font = self.productTypeTitleLabel.font = self.priceTitleLabel.font = self.confirmTimeTitleLabel.font = self.statusTitleLabel.font = self.typeTitleLabel.font = self.qtyTitleLabel.font = REGULAR_FONT_SIZE(14.0);
    self.symbolNameLabel.font = SEMI_BOLD_FONT_SIZE(15.0);
    self.statusLabel.font = SEMI_BOLD_FONT_SIZE(14.0);
    self.backgroundColor = [SBITradingUtility getColorForComponentKey:@"LightBackground"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
