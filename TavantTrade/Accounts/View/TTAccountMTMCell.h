//
//  TTAccountMTMCell.h
//  TavantTrade
//
//  Created by TAVANT on 2/11/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTAccountMTMCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *marginUsedForOrders;
@property (weak, nonatomic) IBOutlet UILabel *marginUsed;
@property (weak, nonatomic) IBOutlet UILabel *unrealizedmtmLoss;
@property (weak, nonatomic) IBOutlet UILabel *realizedmtmGain;
@property (weak, nonatomic) IBOutlet UILabel *cncSalesProceeds;
@property (weak, nonatomic) IBOutlet UILabel *marginUsedTitle;
@property (weak, nonatomic) IBOutlet UILabel *unrealizedmtmLossTitle;
@property (weak, nonatomic) IBOutlet UILabel *realizedmtmGainTitle;
@property (weak, nonatomic) IBOutlet UILabel *cncSalesProceedsTitle;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@end
