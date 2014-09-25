//
//  TTRecommendationViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 2/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTRecommendationViewController.h"
#import "TTRecommendationTableViewCell.h"
#import "TTConstants.h"
#import "SBITradingNetworkManager.h"
#import "SBITradingUtility.h"
#import "TTUrl.h"
#import "TTRecommendation.h"

@interface TTRecommendationViewController ()
@property(nonatomic,weak)IBOutlet UISegmentedControl *typeSegmentControl;
@property(nonatomic,weak)IBOutlet UILabel *viewsHeadingLabel;
@property(nonatomic,weak)IBOutlet UILabel *widgetViewsHeadingLabel;
@property(nonatomic,weak)IBOutlet UIButton *cancelButton;
@property(nonatomic,weak)IBOutlet UITableView *viewsTableView;
@property(nonatomic,weak)IBOutlet UITableView *widgetViewsTableView;
@property(nonatomic,strong) NSMutableArray *viewsArray;
@property (nonatomic, weak) IBOutlet UIView *enlargedHeaderView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property(nonatomic,strong) NSMutableArray *buyTypeViewsArray;
@property(nonatomic,strong) NSMutableArray *sellTypeViewsArray;
@property(nonatomic,strong) NSMutableArray *holdViewsArray;
@property(nonatomic,strong) NSMutableArray *currentSelectedViewsArray;
@end

BOOL shouldShowDummyData = YES;

@implementation TTRecommendationViewController

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
    self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isEnlargedView = NO;
//    _currentSelectedViewsArray = [[NSMutableArray alloc] init];
    _viewsHeadingLabel.text = _widgetViewsHeadingLabel.text = NSLocalizedStringFromTable(@"Views_Heading", @"Localizable", @"Views");
    [_cancelButton setTitle:NSLocalizedStringFromTable(@"Cancel_Button_Title", @"Localizable", @"Cancel") forState:UIControlStateNormal];
    
    [_typeSegmentControl setTitle:NSLocalizedStringFromTable(@"Buy_Type", @"Localizable", @"Buy") forSegmentAtIndex:0];
    [_typeSegmentControl setTitle:NSLocalizedStringFromTable(@"Sell_Type", @"Localizable", @"Sell") forSegmentAtIndex:1];
    [_typeSegmentControl setTitle:NSLocalizedStringFromTable(@"Hold_Type", @"Localizable", @"Hold") forSegmentAtIndex:2];
    
    _viewsHeadingLabel.font = SEMI_BOLD_FONT_SIZE(22.0);
    _widgetViewsHeadingLabel.font = SEMI_BOLD_FONT_SIZE(19.0);
    
    _enlargedHeaderView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"ViewsTitleBar"];
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"ViewsTitleBar"];

    _cancelButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);

    NSDictionary *attributes = [NSDictionary dictionaryWithObject:SEMI_BOLD_FONT_SIZE(14.0)
                                                                 forKey:NSFontAttributeName];
    
    [_typeSegmentControl setTitleTextAttributes:attributes
                                   forState:UIControlStateNormal];
    
    _typeSegmentControl.tintColor = [SBITradingUtility getColorForComponentKey:@"Default"];
    
//    _viewsTableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    _viewsTableView.layer.borderWidth = 0.5f;
    
    [self getTheRecommendations];
    // Do any additional setup after loading the view from its nib.
}

-(void)getTheRecommendations{
    
    //always reset the segment control to buy type...
    _typeSegmentControl.selectedSegmentIndex = 0;
    
    shouldShowDummyData = YES;
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    NSString *relativePath = [TTUrl recommendationURL];
    self.viewsArray = [[NSMutableArray alloc] init];
    [networkManager makeGETRequestWithRelativePath:relativePath responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        NSError *jsonParsingError = nil;
        NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
        NSLog(@"%@ and status code is %@",jsonString,response);
        
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        if(responseArray && [responseArray isKindOfClass:[NSArray class]] && [responseArray count] > 0){
            for(NSDictionary *recommendation in responseArray){
                TTRecommendation *rec = [[TTRecommendation alloc] initWithRecommendationDictionary:recommendation];
                NSLog(@"Rec Array %@",rec.targetArray);
                [self.viewsArray addObject:rec];
            }
            [self prepareBuyViewsArray];
            shouldShowDummyData = NO;
        }
        else
            shouldShowDummyData = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_isEnlargedView == YES){
                [self.viewsTableView reloadData];
            }
            else
                [self.widgetViewsTableView reloadData];
        });

        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareBuyViewsArray{
    self.buyTypeViewsArray = [[NSMutableArray alloc] init];
    self.currentSelectedViewsArray = [[NSMutableArray alloc] init];
    for(TTRecommendation *rec in self.viewsArray){
        NSLog(@"%@",rec.type);
        if([rec.type caseInsensitiveCompare:@"Buy"] == NSOrderedSame)
            [self.buyTypeViewsArray addObject:rec];
    }
    self.currentSelectedViewsArray = self.buyTypeViewsArray;
}

-(void)prepareSellViewsArray{
    self.sellTypeViewsArray = [[NSMutableArray alloc] init];
    self.currentSelectedViewsArray = [[NSMutableArray alloc] init];
    for(TTRecommendation *rec in self.viewsArray){
        if([rec.type caseInsensitiveCompare:@"Sell"] == NSOrderedSame)
            [self.sellTypeViewsArray addObject:rec];
    }
    self.currentSelectedViewsArray = self.sellTypeViewsArray;
}

-(void)prepareHoldViewsArray{
    self.holdViewsArray = [[NSMutableArray alloc] init];
    self.currentSelectedViewsArray = [[NSMutableArray alloc] init];
    for(TTRecommendation *rec in self.viewsArray){
        if([rec.type caseInsensitiveCompare:@"Hold"] == NSOrderedSame)
            [self.holdViewsArray addObject:rec];
    }
    self.currentSelectedViewsArray = self.holdViewsArray;
}

#pragma IBAction...

-(IBAction)showEnlargedView:(id)sender{
    [self getTheRecommendations];
    _isEnlargedView = YES;
    [self.viewsDelegate recommendationViewControllerShouldPresentinEnlargedView:self];
}

-(IBAction)dismissTheViewController:(id)sender{
    _isEnlargedView = NO;
    [self prepareBuyViewsArray];
    [self.widgetViewsTableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)didSelectSegment:(id)sender{
    if(self.typeSegmentControl.selectedSegmentIndex == 0){
        [self prepareBuyViewsArray];
    }
    else if(self.typeSegmentControl.selectedSegmentIndex == 1){
        [self prepareSellViewsArray];
    }
    else{
        [self prepareHoldViewsArray];
    }
    
    [self.viewsTableView reloadData];
    
}


#pragma UITableView Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(shouldShowDummyData)
        return 5;
    else
        return [self.currentSelectedViewsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    TTRecommendationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTRecommendationTableViewCell" owner:self options:nil];
        for(id oneObject in nib) {
            
            if([oneObject isKindOfClass:[TTRecommendationTableViewCell class]]) {
                cell = (TTRecommendationTableViewCell *)oneObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
        }
        
    }
    NSLog(@"self.currentSelectedViewsArray %@",self.currentSelectedViewsArray);
    if(!shouldShowDummyData && [self.currentSelectedViewsArray count] > 0)
        [cell configureCellWithObject:[self.currentSelectedViewsArray objectAtIndex:indexPath.row]];
    
    if(_isEnlargedView){
        [cell setFontForEnlargedView];
    }
    else{
        [cell setFontForWidgetView];
    }
    return cell;
}



@end
