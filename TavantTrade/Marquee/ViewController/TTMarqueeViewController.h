//
//  TTMarqueeViewController.h
//  TavantTrade
//
//  Created by Gautham S Shetty on 23/12/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTConstants.h"
#import "MKTickerView.h"

@class AGOrientedTableView;

@interface TTMarqueeViewController : UIViewController <MKTickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *marqueeDatasourceList;
@property (nonatomic, assign)IBOutlet AGOrientedTableView *marqueeTableView;
@property (nonatomic, strong) NSMutableDictionary *marqueeDataDict;

@property (nonatomic, assign) EExchangeType selectedExchangeType;
@property (nonatomic, assign) IBOutlet UIButton *btnExchangeType;
@property (nonatomic, assign) IBOutlet MKTickerView *tickerView;

@end
