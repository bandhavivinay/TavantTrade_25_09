//
//  TTNewsDetailViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 2/3/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNewsData.h"

@class TTNewsDetailViewController;

@protocol TTNewsDetailViewDelegate
-(void)didClickOnNewsButton:(TTNewsDetailViewController *)inController;
@end

@interface TTNewsDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *goToNewsButton;
@property(nonatomic,assign)id <TTNewsDetailViewDelegate> ttNewsDetailDelegate;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int currentIndex;
@end
