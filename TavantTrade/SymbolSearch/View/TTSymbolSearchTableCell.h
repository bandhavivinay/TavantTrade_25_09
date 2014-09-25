//
//  TTSymbolSearchTableCell.h
//  TavantTrade
//
//  Created by Bandhavi on 12/12/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSymbolSearch.h"
#import "TTCellData.h"


@protocol SelectSearchSymbolProtocol <NSObject>
-(void)selectSearchSymbol:(id)symbolSearchData ForCell:(id)cell;
-(void)displayExpiryDatePopOver:(id)cell;
-(void)displayOptionTypePopOver:(id)cell;
-(void)displayStrikePricePopOver:(id)cell;
@end

@interface TTSymbolSearchTableCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIButton *expiryDateButton;
@property(nonatomic,weak)IBOutlet UIButton *optionButton;
@property(nonatomic,weak)IBOutlet UIButton *strikePriceButton;
@property(nonatomic,weak)IBOutlet UILabel *companyNameLabel;
@property(nonatomic,weak)IBOutlet UILabel *symbolNameLabel;
@property(nonatomic,weak)IBOutlet UIButton *selectSymbolButton;
@property(nonatomic,strong)TTCellData *symbolCellData;
@property(nonatomic,assign)NSObject <SelectSearchSymbolProtocol> *selectSymbolDelegate;
-(IBAction)selectTheSymbol:(id)sender;
-(IBAction)setExpiryDate:(id)sender;
-(void)paintUI;
@end
