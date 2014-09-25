

//
//  TTMarketTableViewCell.h
//  TavantTrade
//
//  Created by Bandhavi on 1/15/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTMarketTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView *cellImageView;
@property(nonatomic,weak)IBOutlet UILabel *cellTitleLabel;
@property(nonatomic,weak)IBOutlet UILabel *cellCompanyLabel1;
@property(nonatomic,weak)IBOutlet UILabel *cellCompanyLabel2;
@property(nonatomic,weak)IBOutlet UILabel *cellCompanyValueLabel1;
@property(nonatomic,weak)IBOutlet UILabel *cellCompanyValueLabel2;
@end
