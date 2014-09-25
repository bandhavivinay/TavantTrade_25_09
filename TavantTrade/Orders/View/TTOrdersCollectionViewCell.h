//
//  TTOrdersCollectionViewCell.h
//  TavantTrade
//
//  Created by Bandhavi on 2/17/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTOrder.h"

@interface TTOrdersCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak)IBOutlet UILabel *symbolNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDurTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *disclosedQtyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTypeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *confirmTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtyTitleLabel;

@property(nonatomic,weak)IBOutlet UILabel *exchangeTypeLabel;
@property(nonatomic,weak)IBOutlet UILabel *orderDurationLabel;
@property(nonatomic,weak)IBOutlet UILabel *orderPriceLabel;
@property(nonatomic,weak)IBOutlet UILabel *disclosedQuantityLabel;

@property(nonatomic,weak)IBOutlet UILabel *productTypeLabel;
@property(nonatomic,weak)IBOutlet UILabel *priceTypeLabel;
@property(nonatomic,weak)IBOutlet UILabel *confirmTimeLabel;
@property(nonatomic,weak)IBOutlet UILabel *statusLabel;

@property(nonatomic,weak)IBOutlet UILabel *typeLabel;
@property(nonatomic,weak)IBOutlet UILabel *quantityLabel;
@property(nonatomic,weak)IBOutlet UILabel *comment;



@property(nonatomic,strong)TTOrder *dataSource;

-(void)configureCell;

@end
