//
//  TTMarketDetailViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 1/24/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTMarketDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *percentageChangeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ltpTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyTitleLabel;
@property(nonatomic,assign)int selectedIndex;
@property(nonatomic,assign)BOOL isVolumeData;
@property(nonatomic,assign)NSString *titleLabel;
-(void)populateCompanyArray:(NSMutableArray *)companyArray;
@end
