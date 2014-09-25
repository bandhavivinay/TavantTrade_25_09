//
//  TTMenuViewController.h
//  TavantTrade
//
//  Created by Bandhavi on 12/20/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTConstants.h"



@protocol MenuItemSelection
-(void)didSelectMenuItem:(EApplicationMenuItems)menuItem;
@end

@interface TTMenuViewController : UIViewController
@property(nonatomic,assign)id<MenuItemSelection> delegate;
@end
