//
//  TTNewsCollectionViewCell.h
//  TavantTrade
//
//  Created by Bandhavi on 2/28/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNewsData.h"

@interface TTNewsCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak)IBOutlet UILabel *headingLabel;
@property(nonatomic,weak)IBOutlet UILabel *dateTimeLabel;
@property(nonatomic,weak)IBOutlet UILabel *descriptionLabel;
@property(nonatomic,strong)TTNewsData *dataSource;
-(void)configureCell;
@end
