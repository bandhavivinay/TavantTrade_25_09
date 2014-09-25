//
//  TTOrderSearchTableCell.h
//  TavantTrade
//
//  Created by Bandhavi on 17/06/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTConstants.h"
@class TTOrderSearchTableCell;

@protocol TTOrderSearchDelegate
-(void)didSelectOrderSearchParameter:(TTOrderSearchTableCell *)inSearchTableCell;
@end

@interface TTOrderSearchTableCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIButton *selectionButton;
@property(nonatomic,weak)IBOutlet UILabel *filterParameterLabel;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,assign)ESearchFilterItems currentSearchParameter;
@property(nonatomic,weak)id<TTOrderSearchDelegate> orderSearchDelegate;
@end
