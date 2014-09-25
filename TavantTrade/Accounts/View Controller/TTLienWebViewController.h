//
//  TTLienWebViewController.h
//  TavantTrade
//
//  Created by TAVANT on 2/13/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTAccountsViewController.h"

@interface TTLienWebViewController : UIViewController

@property(nonatomic,strong)NSURLRequest *url;
@property(nonatomic,weak) IBOutlet UIWebView *webView;
@property(nonatomic,weak) IBOutlet UIButton *backButton;
- (IBAction)backButtonCLicked:(id)sender;

@end
