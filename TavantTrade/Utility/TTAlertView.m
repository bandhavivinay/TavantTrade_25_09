//
//  TTAlertView.m
//  TavantTrade
//
//  Created by Bandhavi on 2/20/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTAlertView.h"

@implementation TTAlertView

+ (instancetype)sharedAlert
{
    static TTAlertView *sharedAlertView = nil;
    if(!sharedAlertView)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedAlertView = [[super allocWithZone:nil] init];
            
        });
    }
    
    return sharedAlertView;
}

-(void)showAlertWithMessage:(NSString *)message{

    UIAlertView *watchlistIdAlert = [[UIAlertView alloc] initWithTitle: message message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    watchlistIdAlert.delegate = self;
    [watchlistIdAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.isAlertShown = NO;
}

@end
