//
//  TTWidgetsContainerView.h
//  ContainerView
//
//  Created by Gautham S Shetty on 06/01/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTWidgetsContainerDatasource;

@interface TTWidgetsContainerView : UIView

@property (nonatomic, assign) NSObject <TTWidgetsContainerDatasource> *datasource;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *containerScrollView;
-(void) reloadData;

@end


@protocol TTWidgetsContainerDatasource <NSObject>

- (NSUInteger) numberOfItemsInWidgetContainer:(TTWidgetsContainerView *)inWidgetContainer;
- (UIView *) widgetsContainer:(TTWidgetsContainerView *)inWidgetContainer viewForWidgetsAtIndex:(NSUInteger) inIndex;

@end