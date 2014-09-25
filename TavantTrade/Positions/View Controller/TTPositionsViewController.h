//
//  TTPositionsViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 2/21/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTDiffusionHandler.h"

@protocol TTPositionViewDelegate
-(void)positionViewControllerShouldPresentinEnlargedView:(UIViewController *)inController;
@end

@interface TTPositionsViewController : UIViewController<DiffusionProtocol>
@property(nonatomic,assign)BOOL isEnlargedView;
@property(nonatomic,assign)id<TTPositionViewDelegate> positionViewDelegate;
@property(nonatomic,weak)IBOutlet UIView *widgetView;

-(IBAction)showEnlargedView:(id)sender;

@end
