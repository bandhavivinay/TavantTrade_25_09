//
//  TTDismissingView.m
//  TavantTrade
//
//  Created by Bandhavi on 12/16/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTDismissingView.h"

@implementation TTDismissingView

- (id) initWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector
{
    self = [super initWithFrame:frame];
    
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.selector = selector;
    self.target = target;
    self.shouldDismissOnTouch = YES;
    return self;
}

- (void) addToWindow:(UIWindow*)window
{
    NSUInteger count = window.subviews.count;
    id v = [window.subviews objectAtIndex:count - 1];
    if (![@"UITransitionView" isEqual:NSStringFromClass([v class])]) return;
    v = [window.subviews objectAtIndex:count - 2];
    if (![@"UIDimmingView" isEqual:NSStringFromClass([v class])]) return;
    
    UIView *front = [window.subviews lastObject];
    [window addSubview:self];
    [window bringSubviewToFront:front];
}



- (void) removeDismissView
{
    [self removeFromSuperview];
}

@end