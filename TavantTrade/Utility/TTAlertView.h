//
//  TTAlertView.h
//  TavantTrade
//
//  Created by Bandhavi on 2/20/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTAlertView : NSObject<UIAlertViewDelegate>
@property(nonatomic,assign)BOOL isAlertShown;
+ (instancetype)sharedAlert;
-(void)showAlertWithMessage:(NSString *)message;
@end
