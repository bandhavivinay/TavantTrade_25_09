//
//  TTDismissingView.h
//  TavantTrade
//
//  Created by Bandhavi on 12/16/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTDismissingView : UIView {
}

@property (nonatomic, retain) id target;
@property (nonatomic) SEL selector;
@property(nonatomic,assign) BOOL shouldDismissOnTouch;

-(id)initWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector;
- (void) addToWindow:(UIWindow*)window;
- (void) removeDismissView;
@end