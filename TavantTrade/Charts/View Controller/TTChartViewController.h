//
//  TTChartViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 1/31/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDiffusionHandler.h"


typedef enum _EChartFrequencyType
{
    eOneDay = 0,
    eFiveDay,
    eOneWeek,
    eOneMonth,
    eSixMonth,
    eOneYear
}EChartFrequencyType;


typedef enum _EChartType
{
    eLineChart = 0,
    eOHLCChart,
    eAreaChart,
    eCandleStickChart
}EChartType;


@protocol TTChartViewDelegate
-(void)chartViewControllerShouldPresentinEnlargedView:(UIViewController *)inController;
@end

@interface TTChartViewController : UIViewController<DiffusionProtocol,UIWebViewDelegate>
@property(nonatomic,assign)BOOL shouldShowBackButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property(nonatomic,weak)IBOutlet UIView *widgetView;
@property(nonatomic,assign)NSObject <TTChartViewDelegate> *ttChartDelegate;
@property(nonatomic,assign)BOOL isEnlargedView;
@property(nonatomic,strong)NSString *previousScreenTitle;
@property(nonatomic,assign)CGRect previousScreenFrame;

@property (nonatomic, assign) EChartFrequencyType selectedFrequencyType;
@property (nonatomic, assign) EChartType selectedChartType;
-(IBAction)showEnlargedView:(id)sender;
@end
