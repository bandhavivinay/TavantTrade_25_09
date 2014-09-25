//
//  TTRecommendationTableViewCell.h
//  TavantTrade
//
//  Created by Bandhavi on 2/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTRecommendation.h"

@interface TTRecommendationTableViewCell : UITableViewCell
-(void)setFontForEnlargedView;
-(void)setFontForWidgetView;
-(void)configureCellWithObject:(TTRecommendation *)inObject;
@end
