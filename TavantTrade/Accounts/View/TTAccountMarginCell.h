//
//  TTAccountMarginCell.h
//  TavantTrade
//
//  Created by TAVANT on 2/10/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTAccountMarginCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *additinalAdhocMargin;
@property (weak, nonatomic) IBOutlet UILabel *adhocMargin;
@property (weak, nonatomic) IBOutlet UILabel *directCollatral;
@property (weak, nonatomic) IBOutlet UILabel *nationalCash;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (weak, nonatomic) IBOutlet UILabel *adhocMarginTitle;
@property (weak, nonatomic) IBOutlet UILabel *directCollatralTitle;
@property (weak, nonatomic) IBOutlet UILabel *nationalCashTitle;

@property (weak, nonatomic) IBOutlet UILabel *valueInRupee;
@end
