//
//  TTNewsDetailViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 2/3/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTNewsDetailViewController.h"
#import "SBITradingUtility.h"

@interface TTNewsDetailViewController ()
@property(nonatomic,assign)IBOutlet UILabel *newsHeadingLabel;
@property(nonatomic,assign)IBOutlet UILabel *dateLabel;
@property(nonatomic,weak)IBOutlet UIWebView *newsDescriptionWebView;
@end

@implementation TTNewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 420, 388);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set news button title ...
    [_goToNewsButton setTitle:NSLocalizedStringFromTable(@"Cancel_Button_Title", @"Localizable", @"Cancel") forState:UIControlStateNormal];
    _newsHeadingLabel.font = REGULAR_FONT_SIZE(18.0);
    _goToNewsButton.titleLabel.font = SEMI_BOLD_FONT_SIZE(15.5);
    _dateLabel.font = REGULAR_FONT_SIZE(11.0);
    
    // Do any additional setup after loading the view from its nib.
}

-(void)paintUIWith:(TTNewsData *)inNewsData{
    _newsHeadingLabel.text = inNewsData.heading;
    //perform date formatting ...
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSDate *date  = [dateFormatter dateFromString:inNewsData.date];
    
    NSDateFormatter *finalDateFormatter = [[NSDateFormatter alloc] init];
    [finalDateFormatter setDateFormat:@"dd MMM yyyy,HH:mm"];
    
    _dateLabel.text = [finalDateFormatter stringFromDate:date];
    
    NSString *htmlString = inNewsData.description;
    [self.newsDescriptionWebView loadHTMLString:htmlString baseURL:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    TTNewsData *currentNews = [_dataSource objectAtIndex:_currentIndex];
    [self paintUIWith:currentNews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma IBAction methods

-(IBAction)goToNextNews:(id)sender{
    if(++_currentIndex < [_dataSource count]){
        TTNewsData *currentNews = [_dataSource objectAtIndex:_currentIndex];
        [self paintUIWith:currentNews];
    }
    else{
        --_currentIndex;
    }
    
}

-(IBAction)goToPreviousNews:(id)sender{
    if(--_currentIndex >= 0){
        TTNewsData *currentNews = [_dataSource objectAtIndex:_currentIndex];
        [self paintUIWith:currentNews];
    }
    else{
        ++_currentIndex;
    }
}

-(IBAction)newsButtonAction:(id)sender{
    [self.ttNewsDetailDelegate didClickOnNewsButton:self];
}

@end
