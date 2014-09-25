//
//  TTMarketDetailTableViewCell.h
//  TavantTrade
//
//  Created by Bandhavi on 1/24/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTMarketDetailTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *companyNameLabel;
@property(nonatomic,weak)IBOutlet UILabel *ltpLabel;
@property(nonatomic,weak)IBOutlet UILabel *changeLabel;
@end
