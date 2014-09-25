//
//  TTRecommendationViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 2/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTViewsDelegate
-(void)recommendationViewControllerShouldPresentinEnlargedView:(UIViewController *)inController;
@end

@interface TTRecommendationViewController : UIViewController
@property(nonatomic,weak)IBOutlet UIView *widgetView;
@property(nonatomic,assign)id<TTViewsDelegate> viewsDelegate;
@property(nonatomic,assign)BOOL isEnlargedView;

-(IBAction)showEnlargedView:(id)sender;

@end
