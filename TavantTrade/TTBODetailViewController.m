//
//  TTBODetailViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 23/06/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTBODetailViewController.h"

@interface TTBODetailViewController ()
@property(nonatomic,weak)IBOutlet UIWebView *backOfficeWebView;
@end

@implementation TTBODetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    //self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
    self.navigationController.view.bounds = CGRectMake(0, 0, 428, 506);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.webURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_backOfficeWebView loadRequest:requestObj];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
