//
//  TTLienWebViewController.m
//  TavantTrade
//
//  Created by TAVANT on 2/13/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTLienWebViewController.h"

@interface TTLienWebViewController ()


@end

@implementation TTLienWebViewController
@synthesize url,webView,backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    NSLog(@"Request is %@",url);
   
    [webView loadRequest:url];
    [webView setScalesPageToFit:YES];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
    self.navigationController.view.superview.bounds = CGRectMake(0, 0, 428, 506);

}

- (IBAction)backButtonCLicked:(id)sender {
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

}
@end
