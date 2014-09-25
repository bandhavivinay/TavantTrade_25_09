//
//  TTCustomViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 3/11/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTCustomViewController.h"

@interface TTCustomViewController ()

@end

@implementation TTCustomViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id)initWithRootViewController:(UIViewController *)rootViewController{
    if ((self = [super initWithRootViewController:rootViewController])) {
        [rootViewController view];
        self.navigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
