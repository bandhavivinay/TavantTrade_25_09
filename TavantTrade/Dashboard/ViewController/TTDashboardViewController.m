//
//  TTDashboardViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 12/11/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTDashboardViewController.h"
#import "TTSymbolDetails.h"
#import "TTConstants.h"
#import "SBITradingNetworkManager.h"
#import "SBITradingUtility.h"
#import "TTSymbolData.h"
#import "TTWidgetsViewController.h"
#import "TTWidgetsViewController.h"
#import "TTSettingsViewController.h"
#import "TTFeedbackViewController.h"
#import "FeedbackSubCategory.h"
#import "FeedbackCategory.h"
#import "TTAppDelegate.h"
#import "TTBackOfficeViewController.h"

@interface TTDashboardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dashboardHeadingLabel;
@property(nonatomic,strong)TTMenuViewController *menuView;
@property(nonatomic,weak)IBOutlet UIView *rightPaneView;
@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;
@property(nonatomic,assign)EExchangeType currentExchangeType;
@property(nonatomic,strong)UIPopoverController *symbolSearchPopOver;
@property(nonatomic,strong)TTGlobalSymbolSearchViewController *searchViewController;
@property (nonatomic, strong) TTSettingsViewController *settingsViewController;
@property (nonatomic, strong) TTScatterMapViewController *scatterMapViewController;
@property(nonatomic,weak)IBOutlet UIScrollView *bottomScrollView;
@property (nonatomic, strong) TTWatchlistController *watchListView;
@property (nonatomic, strong) TTNewsViewController *newsListView;
@property (nonatomic, strong) TTFeedbackViewController *feedbackViewController;
@property (nonatomic, strong) TTBackOfficeViewController *backOfficeViewController;
@property (nonatomic, strong) UINavigationController *newsListNavController;
@property(nonatomic,weak)IBOutlet UIPageControl *bottomPageControl;
@property(nonatomic,weak)IBOutlet UILabel *accountNumberHeadingLabel;


-(IBAction)showMenu:(id)sender;
@end

BOOL isMenuActive = NO;

@implementation TTDashboardViewController

@synthesize menuView,symbolSearchPopOver;
@synthesize widgetsViewController;
@synthesize watchListView = _watchListView;
@synthesize newsListView = _newsListView;
@synthesize searchViewController = _searchViewController;
@synthesize bottomPageControl = _bottomPageControl;
@synthesize newsListNavController = _newsListNavController;

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
    
    
    //check db ...

    
//    NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"FeedbackSubCategory" inManagedObjectContext:appDelegate.managedObjectContext];
//    [request2 setEntity:entity2];
//    NSError *error;
//    NSArray *results2 = [appDelegate.managedObjectContext executeFetchRequest:request2 error:&error];
//    NSLog(@"%@",results2);

    
    _dashboardHeadingLabel.text = NSLocalizedStringFromTable(@"DashBoard_Heading", @"Localizable", @"DashBoard");
    _dashboardHeadingLabel.font = [UIFont fontWithName:@"OpenSans" size:23.0f];
    _accountNumberLAbel.font = _accountNumberHeadingLabel.font = [UIFont fontWithName:@"OpenSans" size:20.0f];
    _dashboardHeadingLabel.textColor = _accountNumberLAbel.textColor = _accountNumberHeadingLabel.textColor = [UIColor colorWithRed:180.0/255.0 green:190.0/255.0 blue:210.0/255.0 alpha:1.0];
    
    //lets load the default symbol to populate the widget...
    [SBITradingUtility searchSymbolWithText:@"ACC" WithExchangeType:eNSE andInstrumentType:EQUITY];
    self.searchBar.text = @"ACC";
    
    //set the content size of the scroll view...
    
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.frame.size.width * 2, self.bottomScrollView.frame.size.height);
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateExchangeType:) name:@"UpdateExchangeType" object:nil];
    //add the menu view behind the controller...
    if(menuView == nil)
        menuView = [[TTMenuViewController alloc] initWithNibName:@"TTMenuViewController" bundle:nil];
    CGRect frame = CGRectMake(0, 0, menuView.view.frame.size.width, menuView.view.frame.size.height);
    menuView.view.frame = frame;
    menuView.delegate = self;
    [self.view addSubview:menuView.view];
    [self.view bringSubviewToFront:self.rightPaneView];
    
    if(!_watchListView){
        _watchListView = [[TTWatchlistController alloc] initWithNibName:@"TTWatchlistController" bundle:nil];
        _watchListView.parentController = self;
        _watchListView.watchlistDelegate = self;
    }
    [self.bottomScrollView addSubview:_watchListView.view];
    
    //add the news component as well and make it a navigation controller ...
    
    if(!_newsListView){
        _newsListView = [[TTNewsViewController alloc] initWithNibName:@"TTNewsViewController" bundle:nil];
        _newsListNavController = [[UINavigationController alloc] initWithRootViewController:_newsListView];
        _newsListView.newsDelegate = self;
        CGRect newsViewFrame = CGRectMake(_watchListView.view.frame.size.width, 0, _newsListView.view.frame.size.width, _newsListView.view.frame.size.height);
        [_newsListNavController.view setFrame:newsViewFrame];
    }

    [self.bottomScrollView addSubview:_newsListNavController.view];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateExchangeType" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateExchangeType" object:nil];
    // Dispose of any resources that can be recreated.
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        // Page has changed
        // Do your thing!
        previousPage = page;
        _bottomPageControl.currentPage = page;
        //NSLog(@"Page number is %d %d",page,previousPage);
    }
}

#pragma IBAction Delegates

- (IBAction)changePageAction:(id) sender
{
    NSUInteger currentPage = _bottomPageControl.currentPage;
    CGFloat width = self.bottomScrollView.bounds.size.width;
    CGRect currentVisibleRect = CGRectMake(width * currentPage, 0.0, width, self.bottomScrollView.bounds.size.height);
    [self.bottomScrollView scrollRectToVisible:currentVisibleRect animated:YES];
}

-(IBAction)showMenu:(id)sender{
    
    CGRect viewFrame=self.rightPaneView.frame;
    
    if(!isMenuActive){
        viewFrame.origin.x=200;
        isMenuActive = YES;
    }
    else{
        viewFrame.origin.x=0;
        isMenuActive = NO;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.rightPaneView.frame=viewFrame;
        
    }completion:nil];
    
}


-(void)didSelectMenuItem:(EApplicationMenuItems )menuItem{
    
    //close the menu...
    
    CGRect viewFrame=self.rightPaneView.frame;
    viewFrame.origin.x=0;
    isMenuActive = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.rightPaneView.frame=viewFrame;
        
    }completion:nil];
    
    
    
    
    switch (menuItem) {
        case eChartMenuItem:
        case eQuoteMenuItem:
        case eMarketMenuItem:
        case eTradeMenuItem:
        case eOrdersMenuItem:
        case ePositionsMenuItem:
        case eOptionsChainMenuItem:
        case eAdminViewsMenuItem:
        case eAccountMenuItem:
        case eAdminMessagesMenuItem:
        {
            [widgetsViewController showWidgetsofType:menuItem];
        }
        break;
        case eNewsMenuItem:{
            [self didNavigateToNewsScreen];
        }
        break;
        case eWatchlistMenuItem:{
            [self didNavigateToWatchListScreen];
        }
        break;
        case eSettingsMenuItem:
        {
            
            if(!_settingsViewController)
            {
                _settingsViewController = [[TTSettingsViewController alloc] initWithNibName:@"TTSettingsViewController" bundle:nil];
                
                
            }
            UINavigationController *navController = [[ UINavigationController alloc] initWithRootViewController:_settingsViewController];
            navController.navigationBarHidden = YES;

            navController.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:navController animated:YES completion:nil];

        }
        break;
            
        case eScatterMapMenuItem:
        {
            
            if(!_scatterMapViewController)
            {
                _scatterMapViewController = [[TTScatterMapViewController alloc] initWithNibName:@"TTScatterMapViewController" bundle:nil];
                _scatterMapViewController.ttTradeScreenDelegate = self;
                
            }
//            UINavigationController *navController = [[ UINavigationController alloc] initWithRootViewController:_scatterMapViewController];
//            navController.navigationBarHidden = YES;
            
            _scatterMapViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:_scatterMapViewController animated:YES completion:nil];
            
        }
            break;
            
        case eCustomerFeedbackMenuItem:
        {
            if(!_feedbackViewController)
            {
                _feedbackViewController = [[TTFeedbackViewController alloc] initWithNibName:@"TTFeedbackViewController" bundle:nil];
            }
            _feedbackViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:_feedbackViewController animated:YES completion:nil];
        }
            break;
            
        case eBackOfficeLogsMenuItem:
        {
            if(!_backOfficeViewController)
            {
                _backOfficeViewController = [[TTBackOfficeViewController alloc] initWithNibName:@"TTBackOfficeViewController" bundle:nil];
            }
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_backOfficeViewController];
            navController.navigationBarHidden = YES;
            
            navController.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:navController animated:YES completion:nil];
        }
            break;

        default:
            break;
    }
    
}

#pragma Orientaion Methods

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

-(NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

-(void)dismissPopOver{
//    symbolSearchPopOver = nil;
    if([symbolSearchPopOver isPopoverVisible]){
        [symbolSearchPopOver dismissPopoverAnimated:YES];
    }
}

//-(void)showSearchPopOver{
//    [self dismissPopOver];
//    if(self.symbolListingViewController == nil){
//        self.symbolListingViewController = [[TTSymbolListingControllerViewController alloc] initWithNibName:@"TTSymbolListingControllerViewController" bundle:nil];
//        self.symbolListingViewController.updateUIDelegate = self;
//    }
//    self.symbolSearchPopOver = [[UIPopoverController alloc] initWithContentViewController:self.symbolListingViewController];
//    [self.symbolSearchPopOver setPopoverContentSize:CGSizeMake(self.symbolListingViewController.view.frame.size.width, self.symbolListingViewController.view.frame.size.height)];
//    [self.symbolSearchPopOver presentPopoverFromRect:[self.searchBar frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//}

//#pragma UISearchBar Delegate Method
//
//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    
//    [searchBar resignFirstResponder];
//    
//}


-(IBAction)performSearch:(id)sender
{
    //open up the global search popup...
//    if(!_searchViewController)
//    {
        _searchViewController = [[TTGlobalSymbolSearchViewController alloc] initWithNibName:@"TTGlobalSymbolSearchViewController" bundle:nil];
        _searchViewController.searchType = eDefault;
        _searchViewController.delegate = self;
//    }
    _searchViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:_searchViewController animated:YES completion:nil];
}

#pragma NSNotification handler
//
//-(void)updateExchangeType:(NSNotification *)inNotification{
//    SBITradingUtility *utility = [SBITradingUtility sharedUtility];
//    int exchangeType = [[inNotification object] intValue];
//    [utility updateExchangeTypeWith:(EExchangeType)exchangeType];
//    self.currentExchangeType = [utility returnCurrentExchangeType];
//}

#pragma delegates

-(void)didNavigateToNewsScreen{
    //scroll to news screen...
    [self.bottomScrollView scrollRectToVisible:CGRectMake(_watchListView.view.frame.size.width, 0, _newsListView.view.frame.size.width, _newsListView.view.frame.size.height) animated:YES];
}

-(void)didNavigateToWatchListScreen{
    //scroll back to watchlist screen...
    [self.bottomScrollView scrollRectToVisible:CGRectMake(0, 0, _newsListView.view.frame.size.width, _newsListView.view.frame.size.height) animated:YES];
}

-(void)didCallDismissPopOver{
    [self dismissPopOver];
}

-(void)updateSearchText:(NSString *)inSearchString{
    self.searchBar.text = inSearchString;
    [self.searchBar resignFirstResponder];
}

-(void)marketViewControllerShouldPresentinEnlargedView:(UINavigationController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
//    NSLog(@"%@ %@",NSStringFromCGRect(inController.view.bounds), NSStringFromCGRect(inController.view.superview.bounds));
//    NSLog(@"%@ %@",NSStringFromCGRect(inController.view.frame), NSStringFromCGRect(inController.view.superview.frame));
    [self presentViewController:inController  animated:YES completion:nil];
//    inController.view.superview.bounds = CGRectMake(0, 0, 428, 506);
//    inController.view.center = CGPointMake(214.0, 253.0);
//    NSLog(@"%f,%f,%f,%f",inController.view.center.x,inController.view.center.y,inController.view.superview.center.x,inController.view.superview.center.y);
}

-(void)presntQuotesView:(UIViewController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
}

-(void)presntTradeView:(UIViewController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
}

-(void)presntWatchlistEntryView:(UIViewController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
}

-(void)quotesViewControllerShouldPresentinEnlargedView:(UIViewController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
}

-(void)chartViewControllerShouldPresentinEnlargedView:(UIViewController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
}

-(void)ordersViewControllerShouldPresentinEnlargedView:(UIViewController *)inController
{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
}

-(void)tradeViewControllerShouldPresentinEnlargedView:(TTTradePopoverController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
}

- (void) globalSymbolSearchViewControllerDidCancelSearch:(TTGlobalSymbolSearchViewController *)inController{
    [inController dismissViewControllerAnimated:YES completion:nil];
}

-(void)AccountViewControllerShouldPresentinEnlargedView:(UIViewController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
    
}

-(void)orderViewControllerShouldPresentinEnlargedView:(UIViewController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
    
}

-(void)positionViewControllerShouldPresentinEnlargedView:(UIViewController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
}

-(void)recommendationViewControllerShouldPresentinEnlargedView:(UIViewController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
}

-(void)MessagesViewControllerShouldPresentinEnlargedView:(UIViewController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
}

-(void)optionChainViewControllerShouldPresentinEnlargedView:(UIViewController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
}

- (void) globalSymbolSearchViewController:(TTGlobalSymbolSearchViewController *)inController didSelectSymbol:(TTSymbolData *)inSymbol{
    //update the global symbol ...
    
    TTSymbolDetails *globalSymbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    globalSymbolDetails.symbolData = inSymbol;
    NSLog(@"Selected symbol is %@",globalSymbolDetails.symbolData.tradeSymbolName);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGlobalSymbol" object:nil];
    
    [inController dismissViewControllerAnimated:YES completion:nil];
}

-(void)tradeNavigationViewControllerShouldPresent:(UIViewController *)inController{
    inController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:inController  animated:YES completion:nil];
}


-(void)dealloc{
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateExchangeType" object:nil];
}

@end
