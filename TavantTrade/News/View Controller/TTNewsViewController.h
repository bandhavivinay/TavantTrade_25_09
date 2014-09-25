//
//  TTNewsViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 1/31/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNewsDetailViewController.h"

@protocol TTNewsViewDelegate
-(void)didNavigateToWatchListScreen;
@end

@interface TTNewsViewController : UIViewController<TTNewsDetailViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property(nonatomic,assign)id <TTNewsViewDelegate> newsDelegate;
@end
