//
//  TTSettingsViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 2/5/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTSettingsViewController.h"
#import "TTConstants.h"
#import "TTWatchlistSettingViewController.h"
#import "WidgetSettingViewController.h"
#import "TTUrl.h"
#import "SBITradingNetworkManager.h"
#import "TTAppDelegate.h"


@interface TTSettingsViewController ()
@property (nonatomic, strong) WidgetSettingViewController *widgetSettingViewController;
@property (nonatomic, strong) TTWatchlistSettingViewController *watchlistSettingViewController;
@property (nonatomic, weak) IBOutlet UILabel *settingsHeadingTitle;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation TTSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"IsStreaming"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"IsStreaming"];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _settingsHeadingTitle.text = NSLocalizedStringFromTable(@"Settings_Heading", @"Localizable", @"Settings");
    //set up the font ...
    _settingsHeadingTitle.font = SEMI_BOLD_FONT_SIZE(22.0);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.navigationController.view.superview.backgroundColor = [UIColor redColor];
    self.navigationController.view.superview.bounds = CGRectMake(0, 0, 425, 554);
}


- (IBAction)showWidgetSettingsView:(id)sender
{
    
}

-(IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(IBAction)logoutAction:(id)sender
{
    
    NSString *relativePath = [TTUrl accountLogoutURL];
    
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    
    [networkManager makeLogoutRequestWithRelativePath:relativePath responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(recievedResponse.statusCode != 200){
                
            }
            else{
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"clientId"];
                    [(TTAppDelegate *) [[UIApplication sharedApplication] delegate] showLoginView];
            }
        });
    }];
}


#pragma UITableView Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;

    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = NSLocalizedStringFromTable(@"Streaming", @"Localizable", @"Streaming");
            UISwitch *streamingSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = streamingSwitch;
            
            BOOL isStreaming = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IsStreaming"] boolValue];
            [streamingSwitch setOn: isStreaming];
            [streamingSwitch addTarget:self action:@selector(streamingSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        break;
        case 1:
        {
            cell.textLabel.text = NSLocalizedStringFromTable(@"Widgets", @"Localizable", @"Widgets");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
            break;
        
        case 2:
        {
            cell.textLabel.text = NSLocalizedStringFromTable(@"Watchlist", @"Localizable", @"Watchlist Columns Selector");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        
        default:
        break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
    {
        if(!_widgetSettingViewController)
        {
            _widgetSettingViewController = [[WidgetSettingViewController alloc] initWithNibName:@"WidgetSettingViewController" bundle:nil];
        }
        _widgetSettingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self.navigationController pushViewController:_widgetSettingViewController animated:YES];

    }
    else if(indexPath.row == 2)
    {
        if(!_watchlistSettingViewController)
        {
            _watchlistSettingViewController = [[TTWatchlistSettingViewController alloc] initWithNibName:@"TTWatchlistSettingViewController" bundle:nil];
        }
        _watchlistSettingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self.navigationController pushViewController:_watchlistSettingViewController animated:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (void)streamingSwitchAction:(id)sender
{
    BOOL isStreaming = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IsStreaming"] boolValue];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:!isStreaming] forKey:@"IsStreaming"];
    [_tableView reloadData];
}

@end
