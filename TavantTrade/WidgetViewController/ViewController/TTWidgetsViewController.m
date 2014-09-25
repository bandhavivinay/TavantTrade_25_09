//
//  TTWidgetsViewController.m
//  TavantTrade
//
//  Created by Gautham S Shetty on 10/01/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTWidgetsViewController.h"
#import "TTMarketViewController.h"
#import "TTQuotesViewController.h"
#import "TTTradeViewController.h"
#import "TTChartViewController.h"
#import "TTOrdersViewController.h"
#import "TTPositionsViewController.h"
#import "TTRecommendationViewController.h"
#import "TTMessagesViewController.h"
#import "TTOptionChainViewController.h"
#import "TTCustomViewController.h"

@interface TTWidgetsViewController ()
@property (nonatomic, strong) IBOutlet TTWidgetsContainerView *widgetContainerView;
@property(nonatomic,strong)TTQuotesViewController *quotesViewController;
@property(nonatomic,strong)TTMarketViewController *marketViewController;
@property(nonatomic,strong)TTChartViewController *chartViewController;
@property(nonatomic,strong)TTOrdersViewController *orderViewController;
@property(nonatomic,strong)TTPositionsViewController *positionViewController;
@property(nonatomic,strong)TTRecommendationViewController *recommendationViewController;
@property(nonatomic,strong)TTMessagesViewController *messagesController;
@property(nonatomic,strong)TTOptionChainViewController *optionChainController;
@property(nonatomic,strong) NSMutableArray * viewArray;
@property(nonatomic,strong)UINavigationController *marketViewNavigationController;
@property(nonatomic,strong)UINavigationController *quotesViewNavigationController;
@property(nonatomic,strong)UINavigationController *chartViewNavigationController;
@property(nonatomic,strong)UINavigationController *accountViewNavigationController;
//@property(nonatomic,strong)UINavigationController *orderViewNavigationController;
@property(nonatomic,strong)UINavigationController *messagesViewNavigationController;
@property(nonatomic,strong)UINavigationController *optionChainNavigationController;
@property(nonatomic,strong)TTDiffusionHandler *diffusion;

@end

BOOL isLoadedOnce = NO;

@implementation TTWidgetsViewController

@synthesize widgetContainerView = _widgetContainerView;
@synthesize viewArray = _viewArray;
@synthesize marketViewController = _marketViewController;
@synthesize quotesViewController = _quotesViewController;
@synthesize chartViewController = _chartViewController;
@synthesize orderViewController = _orderViewController;
@synthesize positionViewController = _positionViewController;
@synthesize recommendationViewController = _recommendationViewController;
@synthesize messagesController=_messagesController;
@synthesize optionChainController = _optionChainController;
@synthesize optionChainNavigationController=_optionChainNavigationController;
@synthesize diffusion;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.viewArray = [[NSMutableArray alloc] init];
        diffusion = [TTDiffusionHandler sharedDiffusionManager];
        [diffusion initDiffusion];
        [diffusion connectWithViewControllerContext:self];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Add market screen in the list...
    
    //Connect to the diffusion server ...
        
    _widgetContainerView.backgroundColor = [UIColor clearColor];
}

-(TTChartViewController *)chartViewController
{
    if(!_chartViewController.widgetView)
    {
        _chartViewController = [[TTChartViewController alloc] initWithNibName:@"TTChartViewController" bundle:nil];
        _chartViewNavigationController = [[TTCustomViewController alloc]initWithRootViewController:_chartViewController];
         _chartViewController.ttChartDelegate = self.dashBoardController;
        
//        [_chartViewController view];
//        self.chartViewNavigationController = [[UINavigationController alloc] initWithRootViewController:_chartViewController];
//        _chartViewNavigationController.navigationBarHidden = YES;
    }
    return _chartViewController;
}

-(TTAccountsViewController *)accountsViewController
{
    if(!_accountsViewController.widgetView)
    {
        _accountsViewController = [[TTAccountsViewController alloc] initWithNibName:@"TTAccountsViewController" bundle:nil];
        _accountViewNavigationController = [[TTCustomViewController alloc]initWithRootViewController:_accountsViewController];
        _accountsViewController.presentEnlargedViewDelegate = self.dashBoardController;
//        [_accountsViewController view];
        
//        _accountViewNavigationController.navigationBarHidden = YES;
    }
    return _accountsViewController;
}

-(TTQuotesViewController *)quotesViewController
{
    if(!_quotesViewController.widgetView)
    {
        _quotesViewController = [[TTQuotesViewController alloc] initWithNibName:@"TTQuotesViewController" bundle:nil];
        _quotesViewNavigationController = [[TTCustomViewController alloc] initWithRootViewController:_quotesViewController];
//        [_quotesViewController view];
        _quotesViewController.ttQuotesDelegate = self.dashBoardController;
//        _quotesViewNavigationController.navigationBarHidden = YES;
    }
    return _quotesViewController;
}

-(TTMarketViewController *)marketViewController
{
    if(!_marketViewController.widgetView)
    {
        _marketViewController = [[TTMarketViewController alloc] initWithNibName:@"TTMarketViewController" bundle:nil];
        _marketViewNavigationController = [[TTCustomViewController alloc] initWithRootViewController:_marketViewController];
//        [_marketViewController view];
        _marketViewController.presentEnlargedViewDelegate = self.dashBoardController;
//        _marketViewNavigationController.navigationBarHidden = YES;

    }
    return _marketViewController;
}

-(TTTradeViewController *)tradeViewController
{
    if(!_tradeViewController)
    {
        _tradeViewController = [[TTTradeViewController alloc] initWithNibName:@"TTTradeViewController" bundle:nil];
    }
    return _tradeViewController;
}

-(TTOrdersViewController *)orderViewController
{
//    NSLog(@"Widget view is %@",self.orderViewController.widgetView);
    if(!_orderViewController.widgetView)
    {
        _orderViewController = [[TTOrdersViewController alloc] initWithNibName:@"TTOrdersViewController" bundle:nil];
        [_orderViewController view];
        _orderViewController.ttOrderViewDelegate = self.dashBoardController;
    }
    return _orderViewController;
}
-(TTPositionsViewController *)positionViewController
{
    if(!_positionViewController.widgetView)
    {
        _positionViewController = [[TTPositionsViewController alloc] initWithNibName:@"TTPositionsViewController" bundle:nil];
        [_positionViewController view];
        _positionViewController.positionViewDelegate = self.dashBoardController;

    }
    return _positionViewController;
}

-(TTOptionChainViewController *)optionChainController
{
    if(!_optionChainController.widgetView)
    {
        _optionChainController = [[TTOptionChainViewController alloc] initWithNibName:@"TTOptionChainViewController" bundle:nil];
        _optionChainNavigationController = [[TTCustomViewController alloc] initWithRootViewController:_optionChainController];
//        [_optionChainController view];
        _optionChainController.optionChainDelegate = self.dashBoardController;

    }
    return _optionChainController;
}

-(TTMessagesViewController *)messagesController
{
    if(!_messagesController.widgetView)
    {
        _messagesController = [[TTMessagesViewController alloc] initWithNibName:@"TTMessagesViewController" bundle:nil];
        _messagesViewNavigationController = [[TTCustomViewController alloc] initWithRootViewController:_messagesController];
//        _messagesViewNavigationController.navigationBarHidden = YES;
//        [_messagesController view];
        _messagesController.messagesViewDelagate = self.dashBoardController;

    }
    return _messagesController;
}

-(TTRecommendationViewController *)recommendationViewController
{
    if(!_recommendationViewController.widgetView)
    {
        _recommendationViewController = [[TTRecommendationViewController alloc] initWithNibName:@"TTRecommendationViewController" bundle:nil];
        [_recommendationViewController view];
        _recommendationViewController.viewsDelegate = self.dashBoardController;

    }
    return _recommendationViewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)WidgetsSettingsDidChange:(NSNotification *)innotif
{
    [self reloadWidgetContainer];
}

-(void)reloadWidgetContainer
{
    
    NSMutableArray *widgets = [[NSUserDefaults standardUserDefaults] objectForKey:KWidgetsSetting];
    //self.chartViewController;
    
    if(!widgets)
    {
        widgets = [[NSMutableArray alloc] initWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eChart],@"Type", @"Charts", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eMarket],@"Type", @"Market", @"Name", [NSNumber numberWithBool:YES], @"ShouldShow", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eQuotes],@"Type", @"Quotes", @"Name", [NSNumber numberWithBool:YES], @"ShouldShow", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eTrade],@"Type", @"Trade", @"Name", [NSNumber numberWithBool:YES], @"ShouldShow", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eOrders],@"Type", @"Orders", @"Name", [NSNumber numberWithBool:YES], @"ShouldShow", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eAccounts],@"Type", @"Accounts", @"Name", [NSNumber numberWithBool:YES], @"ShouldShow", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ePosition],@"Type", @"Positions", @"Name", [NSNumber numberWithBool:YES], @"ShouldShow", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eViews],@"Type", @"Views", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eMessages],@"Type", @"Messages", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eOptionChain],@"Type", @"Option Chain", @"Name", [NSNumber numberWithBool:NO], @"ShouldShow", nil],
                   nil];
        [[NSUserDefaults standardUserDefaults] setObject:widgets forKey:KWidgetsSetting];
    }

//    [_viewArray removeAllObjects];

    _viewArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [widgets count]; i++)
    {
        EWidgets widgetType = [[[widgets objectAtIndex:i] objectForKey:@"Type"] integerValue];
        
        BOOL shouldShow = [[[widgets objectAtIndex:i] valueForKey:@"ShouldShow"] boolValue];
        if (!shouldShow) {
            continue;
        }
        
        switch (widgetType) {
            case eChart:
            {
                // Adding chart view to the widget list ...
                [_viewArray addObject:self.chartViewController.widgetView];
            }
                break;
            case eMarket:
            {
                //Add market view to the widget list ...
                [_viewArray addObject:self.marketViewController.widgetView];
            }
                break;
                
            case eQuotes:
            {
                [_viewArray addObject:self.quotesViewController.widgetView];
            }
                break;
                
            case eOrders:
            {
                NSLog(@"View array is %@ and ******* %@",_viewArray,self.orderViewController.widgetView);
                [_viewArray addObject:self.orderViewController.widgetView];
            }
                break;
                
            case eTrade:
            {
                // Adding trade widget
                [_viewArray addObject:self.tradeViewController.view];
            }
                break;
                
            case eAccounts:
            {
                // Adding accounts widget
                [_viewArray addObject:self.accountsViewController.widgetView];
            }
                break;
              
            case ePosition:
            {
                //Adding Position widget
                [_viewArray addObject:self.positionViewController.widgetView];
            }
                break;
                
            case eViews:
            {
                //Adding Position widget
                [_viewArray addObject:self.recommendationViewController.widgetView];
            }
                break;
            // for messages screen
                
            case eMessages:
            {
                [_viewArray addObject:self.messagesController.widgetView];
            }
                break;
                
            case eOptionChain:
            {
                [_viewArray addObject:self.optionChainController.widgetView];
            }
                break;

            default:
                break;
        }

    }
    
    _widgetContainerView.datasource = self;
    [_widgetContainerView reloadData];
    
}


-(void) showWidgetsofType:(EApplicationMenuItems)inType
{
    switch (inType) {
        case eChartMenuItem:
        {
            // Adding chart view to the widget list ...
            [self.chartViewController showEnlargedView:nil];
        }
        break;
        case eMarketMenuItem:
        {
            [self.marketViewController showEnlargedView:nil];
        }
        break;
        
        case eQuoteMenuItem:
        {
            [self.quotesViewController showEnlargedView:nil];
        }
        break;
        
        case eOrdersMenuItem:
        {
            [self.orderViewController showEnlargedView:nil];

        }
        break;
        
        case eTradeMenuItem:
        {
            [self.tradeViewController showEnlargedView:nil];
        }
        break;
        
        case eAccountMenuItem:
        {
            [self.accountsViewController showEnlargedView:nil];
        }
        break;
        
        case ePositionsMenuItem:
        {
            [self.positionViewController showEnlargedView:nil];
        }
        break;
        
        case eAdminViewsMenuItem:
        {
            [self.recommendationViewController showEnlargedView:nil];
        }
        break;
        // for messages screen
        
        case eAdminMessagesMenuItem:
        {
            [self.messagesController showEnlargedView:nil];
        }
        break;
        
        case eOptionsChainMenuItem:
        {
            [self.optionChainController showEnlargedView:nil];
        }
        break;
        case eWatchlistMenuItem:
        {
        }
        break;
//        case eNewsMenuItem:
//        {
//            
//        }
        break;
        default:
        break;
    }
}


- (NSUInteger) numberOfItemsInWidgetContainer:(TTWidgetsContainerView *)inWidgetContainer
{
    return  [_viewArray count];
}
- (UIView *) widgetsContainer:(TTWidgetsContainerView *)inWidgetContainer viewForWidgetsAtIndex:(NSUInteger) inIndex
{
//    UIView *view = [[UIView alloc] init];
//
//    view.backgroundColor = [ UIColor colorWithRed:10*inIndex/255.0 green:20*inIndex/255.0 blue:30*inIndex/255.0 alpha:1.0];
    
    UIView *tempView = [_viewArray objectAtIndex:inIndex];
    
    return tempView;
}

#pragma Diffusion Delegates

-(void)onConnectionWithStatus:(BOOL)isConnected{
    
//    if(!isLoadedOnce){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WidgetsSettingsDidChange:) name:KWidgetsSettingsDidChangeNotification object:nil];
        //isLoadedOnce = YES;
        [self reloadWidgetContainer];
//    }

}

- (void) dealloc
{
    
}


@end
