//
//  TTPositionTableViewCell.h
//  TavantTrade
//
//  Created by Bandhavi on 2/21/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPositionTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *symbolNameLabel;
@property(nonatomic,weak)IBOutlet UILabel *ltpLabel;

@property(nonatomic,weak)IBOutlet UILabel *averageCostLabel;
@property(nonatomic,weak)IBOutlet UILabel *quantityLabel;

@property(nonatomic,weak)IBOutlet UILabel *profitLabel;
@property(nonatomic,weak)IBOutlet UILabel *profitPercentageLabel;
@property(nonatomic,weak)IBOutlet UILabel *typeLabel;
@end
