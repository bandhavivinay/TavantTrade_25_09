//
//  TTOptionChainTableViewCell.h
//  TavantTrade
//
//  Created by Bandhavi on 3/5/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTCallOption.h"
#import "TTPutOption.h"

@class TTOptionChainTableViewCell;

@protocol SelectSeriesProtocol <NSObject>

-(void)setSelectedSeries:(NSString *)inSeries forCell:(TTOptionChainTableViewCell *)inCell;

@end

@interface TTOptionChainTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel *callBidLabel;
@property(nonatomic,weak)IBOutlet UILabel *callAskLabel;
@property(nonatomic,weak)IBOutlet UILabel *putBidLabel;
@property(nonatomic,weak)IBOutlet UILabel *putAskLabel;
@property(nonatomic,weak)IBOutlet UILabel *callOILabel;
@property(nonatomic,weak)IBOutlet UILabel *putOILabel;
@property(nonatomic,weak)IBOutlet UILabel *callLTPLabel;
@property(nonatomic,weak)IBOutlet UILabel *putLTPLabel;
@property(nonatomic,weak)IBOutlet UILabel *callVolumeLabel;
@property(nonatomic,weak)IBOutlet UILabel *putVolumeLabel;
@property(nonatomic,weak)IBOutlet UILabel *strikePrice;

@property(nonatomic,weak)IBOutlet UIButton *callButton;
@property(nonatomic,weak)IBOutlet UIButton *putButton;

@property(nonatomic,weak)id<SelectSeriesProtocol> seriesSelectedDelegate;

-(void)updateCellWithCallOption:(TTCallOption *)inCallOption andPutOption:(TTPutOption *)inPutOption;
//-(IBAction)callOptionSelected:(id)sender;
//-(IBAction)putOptionSelected:(id)sender;
@end
