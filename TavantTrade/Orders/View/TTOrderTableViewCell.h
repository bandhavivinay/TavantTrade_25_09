//
//  TTOrderTableViewCell.h
//  TavantTrade
//
//  Created by Bandhavi on 2/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *symbolHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property(nonatomic,weak)IBOutlet UILabel *symbolNameLabel;
@property(nonatomic,weak)IBOutlet UILabel *orderTypeLabel;
@property(nonatomic,weak)IBOutlet UILabel *statusLabel;
@end
