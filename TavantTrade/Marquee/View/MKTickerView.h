//
//  MKTickerView.h
//  MKTickerViewDemo
//
//  Created by Mugunth on 09/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.

//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above
//  Read my blog post at http://mk.sg/8i on how to use this code

//  As a side note on using this code, you might consider giving some credit to me by
//	1) linking my website from your app's website 
//	2) or crediting me inside the app's credits page 
//	3) or a tweet mentioning @mugunthkumar
//	4) A paypal donation to mugunth.kumar@gmail.com
//
//  A note on redistribution
//	While I'm ok with modifications to this source code, 
//	if you are re-publishing after editing, please retain the above copyright notices

#import <UIKit/UIKit.h>
#import "TTDiffusionData.h"
@class MKTickerView;
@class MKTickerItemView;

@protocol MKTickerViewDataSource <NSObject>
@required
- (UIColor*) backgroundColorForTickerView:(MKTickerView*) tickerView;
- (int) numberOfItemsForTickerView:(MKTickerView*) tickerView;

- (id) tickerView:(MKTickerView *)tickerView dataForItemAtIndex:(NSUInteger) index;
@end

@interface MKTickerView : UIScrollView {
  
}

@property (nonatomic, assign) IBOutlet id <MKTickerViewDataSource> dataSource;

-(void) reloadData;
-(void) reloadItemAtIndex : (NSUInteger) index;
-(void) startAnimation;
-(MKTickerItemView *)tickerItemViewAtIndex:(NSUInteger )index;

@end

@interface MKTickerItemView : UIView
  
@property (nonatomic, strong) TTDiffusionData *data;

@end