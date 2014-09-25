//
//  TTOrdersViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 2/17/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDiffusionHandler.h"
#import "TTOrderSearchTableCell.h"


typedef enum OrderStatus{
    eOpen = 0,
    eAll = 1,
    eExecuted
}EOrderStatus;

@protocol TTOrderViewDelegate
-(void)orderViewControllerShouldPresentinEnlargedView:(UIViewController *)inController;
@end

@interface TTOrdersViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,DiffusionProtocol,UIGestureRecognizerDelegate,UISearchBarDelegate,TTOrderSearchDelegate,UIAlertViewDelegate>
@property(nonatomic,weak)IBOutlet UIView *widgetView;
@property (weak, nonatomic) IBOutlet UILabel *orderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderWidgetTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property(nonatomic,assign)id<TTOrderViewDelegate> ttOrderViewDelegate;
@property(nonatomic,assign)BOOL isEnlargedView;
@property(nonatomic,weak)IBOutlet UICollectionView *ordersCollectionView;
@property(nonatomic,assign)EOrderStatus orderStatus;

-(IBAction)showEnlargedView:(id)sender;

@end
