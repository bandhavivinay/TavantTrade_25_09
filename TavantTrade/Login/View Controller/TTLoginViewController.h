//
//  TTLoginViewController.h
//  TavantTrade
//
//  Created by TAVANT on 2/19/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTDashboardViewController.h"



@interface TTLoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonClickAction:(id)sender;

@end
